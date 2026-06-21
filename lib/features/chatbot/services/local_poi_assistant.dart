import '../../../core/constants/api_keys.dart';
import '../../../domain/entities/checkpoint.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/route_poi.dart';
import 'route_context_builder.dart';

class LocalPoiAssistant {
  Future<String> askAboutRoute({
    required String userQuestion,
    required List<RoutePoiEntity> routePois,
    required JourneyEntity journey,
    required List<CheckpointEntity> checkpoints,
  }) async {
    final text = RouteContextBuilder.buildLocalReply(
      journey: journey,
      routePois: routePois,
      checkpoints: checkpoints,
      userQuestion: userQuestion,
    );

    if (!ApiKeys.hasGeminiApiKey &&
        routePois.isNotEmpty &&
        !text.contains('could not find mapped stops')) {
      return '$text\n\n_Add --dart-define=GEMINI_API_KEY=... for AI-powered tour-guide replies._';
    }

    return text;
  }
}
