import '../../../core/constants/api_keys.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/checkpoint.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/route_poi.dart';
import 'gemini_service.dart';
import 'local_poi_assistant.dart';
import 'route_assistant_exception.dart';

class RouteAssistantResult {
  final String text;
  final bool usedLocalFallback;

  const RouteAssistantResult({
    required this.text,
    required this.usedLocalFallback,
  });
}

class RouteAssistantService {
  final GeminiService _gemini;
  final LocalPoiAssistant _local;

  RouteAssistantService({
    GeminiService? gemini,
    LocalPoiAssistant? local,
  })  : _gemini = gemini ?? GeminiService(),
        _local = local ?? LocalPoiAssistant();

  bool get isGeminiConfigured => ApiKeys.hasGeminiApiKey;

  Future<RouteAssistantResult> askAboutRoute({
    required String userQuestion,
    required List<RoutePoiEntity> routePois,
    required JourneyEntity journey,
    required List<CheckpointEntity> checkpoints,
    required List<ChatMessageEntity> history,
  }) async {
    if (!ApiKeys.hasGeminiApiKey) {
      final text = await _local.askAboutRoute(
        userQuestion: userQuestion,
        routePois: routePois,
        journey: journey,
        checkpoints: checkpoints,
      );
      return RouteAssistantResult(text: text, usedLocalFallback: true);
    }

    try {
      final text = await _gemini.askAboutRoute(
        userQuestion: userQuestion,
        routePois: routePois,
        journey: journey,
        checkpoints: checkpoints,
        history: history,
      );
      return RouteAssistantResult(text: text, usedLocalFallback: false);
    } on RouteAssistantException {
      final localText = await _local.askAboutRoute(
        userQuestion: userQuestion,
        routePois: routePois,
        journey: journey,
        checkpoints: checkpoints,
      );
      return RouteAssistantResult(
        text: '📍 Using local route guide (AI unavailable):\n\n$localText',
        usedLocalFallback: true,
      );
    } catch (_) {
      final localText = await _local.askAboutRoute(
        userQuestion: userQuestion,
        routePois: routePois,
        journey: journey,
        checkpoints: checkpoints,
      );
      return RouteAssistantResult(
        text: '📍 Using local route guide (offline or API error):\n\n$localText',
        usedLocalFallback: true,
      );
    }
  }
}
