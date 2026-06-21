import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/route_poi.dart';
import '../../journey_management/providers/journey_details_provider.dart';
import '../models/route_poi_indexing_state.dart';
import '../services/overpass_service.dart';
import '../services/route_assistant_service.dart';
import '../services/route_pipeline_service.dart';
import '../../../core/providers/network_provider.dart';

part 'chatbot_provider.g.dart';

@riverpod
OverpassService overpassService(OverpassServiceRef ref) {
  return OverpassService(ref.watch(dioProvider));
}

@riverpod
RouteAssistantService routeAssistantService(RouteAssistantServiceRef ref) {
  return RouteAssistantService();
}

@riverpod
RoutePipelineService routePipelineService(RoutePipelineServiceRef ref) {
  final service = RoutePipelineService(
    ref.watch(routePoiRepositoryProvider),
    ref.watch(overpassServiceProvider),
  );
  service.onStatusChanged = (journeyId, status) {
    ref.read(routePoiIndexingStatusProvider(journeyId).notifier).setStatus(status);
  };
  return service;
}

@riverpod
bool chatbotAiEnabled(ChatbotAiEnabledRef ref) {
  return ref.watch(routeAssistantServiceProvider).isGeminiConfigured;
}

@riverpod
Stream<List<RoutePoiEntity>> routePois(RoutePoisRef ref, String journeyId) {
  return ref.watch(routePoiRepositoryProvider).watchPois(journeyId);
}

@riverpod
class RoutePoiIndexingStatus extends _$RoutePoiIndexingStatus {
  @override
  RoutePoiIndexingState build(String journeyId) {
    ref.listen(routePoisProvider(journeyId), (previous, next) {
      next.whenData((pois) {
        if (pois.isNotEmpty) {
          state = RoutePoiIndexingState.ready;
        }
      });
    });

    final pois = ref.watch(routePoisProvider(journeyId)).valueOrNull;
    if (pois != null && pois.isNotEmpty) {
      return RoutePoiIndexingState.ready;
    }
    return RoutePoiIndexingState.idle;
  }

  void setStatus(RoutePoiIndexingState status) {
    if (status == RoutePoiIndexingState.indexing ||
        status == RoutePoiIndexingState.failed) {
      state = status;
      return;
    }
    if (status == RoutePoiIndexingState.ready) {
      state = RoutePoiIndexingState.ready;
    }
  }

  void startIndexing() {
    if (state != RoutePoiIndexingState.ready) {
      state = RoutePoiIndexingState.indexing;
    }
  }
}

@riverpod
bool chatbotReady(ChatbotReadyRef ref, String journeyId) {
  final pois = ref.watch(routePoisProvider(journeyId)).valueOrNull ?? const [];
  return pois.isNotEmpty;
}

@riverpod
bool chatbotPoisLoading(ChatbotPoisLoadingRef ref, String journeyId) {
  final status = ref.watch(routePoiIndexingStatusProvider(journeyId));
  return status == RoutePoiIndexingState.indexing;
}

@riverpod
bool chatbotIndexingFailed(ChatbotIndexingFailedRef ref, String journeyId) {
  final status = ref.watch(routePoiIndexingStatusProvider(journeyId));
  return status == RoutePoiIndexingState.failed;
}

@riverpod
Future<void> retryRoutePoiIndexing(
  RetryRoutePoiIndexingRef ref,
  String journeyId,
) async {
  final journey =
      await ref.read(journeyRepositoryProvider).getJourney(journeyId);
  if (journey == null) return;

  ref.read(routePoiIndexingStatusProvider(journeyId).notifier).startIndexing();
  await ref.read(routePipelineServiceProvider).initializeForJourney(
        journey,
        force: true,
      );
}

@riverpod
class ChatbotMessagesNotifier extends _$ChatbotMessagesNotifier {
  @override
  Stream<List<ChatMessageEntity>> build(String journeyId) {
    return ref.watch(chatRepositoryProvider).watchMessages(journeyId);
  }

  Future<List<RoutePoiEntity>> _waitForRoutePois() async {
    final poiRepo = ref.read(routePoiRepositoryProvider);

    final cached = ref.read(routePoisProvider(journeyId)).valueOrNull ??
        await poiRepo.getPois(journeyId);
    if (cached.isNotEmpty) return cached;

    try {
      return await poiRepo
          .watchPois(journeyId)
          .firstWhere((pois) => pois.isNotEmpty)
          .timeout(const Duration(seconds: 45));
    } on TimeoutException {
      throw Exception(
        'Route places are still loading. Please wait for indexing to finish.',
      );
    }
  }

  Future<void> sendMessage(String text) async {
    if (!ref.read(chatbotReadyProvider(journeyId))) {
      return;
    }

    final chatRepo = ref.read(chatRepositoryProvider);
    final currentMessages = state.valueOrNull ?? [];

    final userMsg = ChatMessageEntity(
      id: const Uuid().v4(),
      journeyId: journeyId,
      role: 'user',
      content: text,
      createdAt: DateTime.now(),
    );

    await chatRepo.saveMessage(userMsg);

    final typingId = const Uuid().v4();
    final typingMsg = ChatMessageEntity(
      id: typingId,
      journeyId: journeyId,
      role: 'assistant',
      content: 'Thinking...',
      createdAt: DateTime.now().add(const Duration(milliseconds: 10)),
    );

    await chatRepo.saveMessage(typingMsg);

    try {
      final journeyRepo = ref.read(journeyRepositoryProvider);

      final journey =
          ref.read(watchJourneyDetailsProvider(journeyId)).valueOrNull ??
              await journeyRepo.getJourney(journeyId);
      if (journey == null) throw Exception('Journey not found');

      final checkpoints =
          ref.read(watchCheckpointsProvider(journeyId)).valueOrNull ??
              await journeyRepo.getCheckpoints(journeyId);

      final pois = await _waitForRoutePois();

      final result =
          await ref.read(routeAssistantServiceProvider).askAboutRoute(
                userQuestion: text,
                routePois: pois,
                journey: journey,
                checkpoints: checkpoints,
                history: currentMessages,
              );

      final assistantMsg = ChatMessageEntity(
        id: typingId,
        journeyId: journeyId,
        role: 'assistant',
        content: result.text,
        createdAt: DateTime.now(),
      );

      await chatRepo.saveMessage(assistantMsg);
    } catch (e) {
      final message = e is Exception && e.toString().contains('still loading')
          ? 'Route places are still being indexed. Please wait for the tour guide to finish loading, then try again.'
          : 'Sorry, I could not answer that right now. Please check your connection and try again.';

      final errorMsg = ChatMessageEntity(
        id: typingId,
        journeyId: journeyId,
        role: 'assistant',
        content: message,
        createdAt: DateTime.now(),
      );
      await chatRepo.saveMessage(errorMsg);
    }
  }

  Future<void> clearHistory() async {
    await ref.read(chatRepositoryProvider).clearMessages(journeyId);
  }
}
