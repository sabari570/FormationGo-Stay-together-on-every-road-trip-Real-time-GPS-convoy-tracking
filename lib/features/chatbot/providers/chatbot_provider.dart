import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/network_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../data/database/app_database.dart';
import '../services/gemini_service.dart';
import '../services/overpass_service.dart';
import '../services/places_service.dart';
import '../services/route_pipeline_service.dart';

part 'chatbot_provider.g.dart';

@riverpod
PlacesService placesService(PlacesServiceRef ref) {
  return PlacesService(ref.watch(dioProvider));
}

@riverpod
OverpassService overpassService(OverpassServiceRef ref) {
  return OverpassService(ref.watch(dioProvider));
}

@riverpod
GeminiService geminiService(GeminiServiceRef ref) {
  return GeminiService();
}

@riverpod
RoutePipelineService routePipelineService(RoutePipelineServiceRef ref) {
  return RoutePipelineService(
    ref.watch(appDatabaseProvider),
    ref.watch(placesServiceProvider),
    ref.watch(overpassServiceProvider),
  );
}

@riverpod
class ChatbotMessagesNotifier extends _$ChatbotMessagesNotifier {
  @override
  Future<List<ChatMessage>> build(String journeyId) async {
    final db = ref.watch(appDatabaseProvider);
    final query = db.select(db.chatMessages)
      ..where((t) => t.journeyId.equals(journeyId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]);
    return query.get();
  }

  Future<void> sendMessage(String text) async {
    final db = ref.watch(appDatabaseProvider);
    final currentMessages = state.value ?? [];

    // 1. Add & Save user message
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      journeyId: journeyId,
      role: 'user',
      content: text,
      createdAt: DateTime.now(),
    );

    state = AsyncValue.data([...currentMessages, userMsg]);
    await db.into(db.chatMessages).insert(userMsg);

    // 2. Add temporary typing response placeholder
    final typingId = const Uuid().v4();
    final typingMsg = ChatMessage(
      id: typingId,
      journeyId: journeyId,
      role: 'assistant',
      content: 'Thinking...',
      createdAt: DateTime.now().add(const Duration(milliseconds: 10)),
    );

    state = AsyncValue.data([...state.value!, typingMsg]);

    try {
      // 3. Fetch data for prompt
      final journey = await ref.read(journeyRepositoryProvider).getJourney(journeyId);
      if (journey == null) throw Exception("Journey not found");
      final pois = await (db.select(db.routePois)..where((t) => t.journeyId.equals(journeyId))).get();

      // 4. Ask Gemini
      final responseText = await ref.read(geminiServiceProvider).askAboutRoute(
        userQuestion: text,
        routePois: pois,
        journey: journey,
        history: currentMessages,
      );

      final assistantMsg = ChatMessage(
        id: typingId,
        journeyId: journeyId,
        role: 'assistant',
        content: responseText,
        createdAt: DateTime.now(),
      );

      await db.into(db.chatMessages).insertOnConflictUpdate(assistantMsg);

      final updated = state.value!.map((m) => m.id == typingId ? assistantMsg : m).toList();
      state = AsyncValue.data(updated);
    } catch (e, st) {
      print('Chatbot error encountered: $e\n$st');
      final errorMsg = ChatMessage(
        id: typingId,
        journeyId: journeyId,
        role: 'assistant',
        content: 'Failed to connect: $e\n\nPlease check your network connection and make sure your Gemini API key is valid.',
        createdAt: DateTime.now(),
      );
      state = AsyncValue.data(state.value!.map((m) => m.id == typingId ? errorMsg : m).toList());
    }
  }

  Future<void> clearHistory() async {
    final db = ref.watch(appDatabaseProvider);
    await (db.delete(db.chatMessages)..where((t) => t.journeyId.equals(journeyId))).go();
    state = const AsyncValue.data([]);
  }
}

@riverpod
Stream<bool> chatbotReady(ChatbotReadyRef ref, String journeyId) {
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.routePois)..where((t) => t.journeyId.equals(journeyId));
  return query.watch().map((list) => list.isNotEmpty);
}
