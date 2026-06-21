import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/api_keys.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/checkpoint.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/route_poi.dart';
import 'route_assistant_exception.dart';
import 'route_context_builder.dart';

class GeminiService {
  static const _modelFallbackChain = [
    'gemini-2.5-flash',
    'gemini-2.0-flash',
    'gemini-1.5-flash',
  ];

  GeminiService();

  Future<String> askAboutRoute({
    required String userQuestion,
    required List<RoutePoiEntity> routePois,
    required JourneyEntity journey,
    required List<CheckpointEntity> checkpoints,
    required List<ChatMessageEntity> history,
  }) async {
    if (!ApiKeys.hasGeminiApiKey) {
      throw const RouteAssistantException(
        'Gemini API key is not configured.',
        isRetryable: false,
      );
    }

    final routeContext = RouteContextBuilder.buildSystemContext(
      journey: journey,
      routePois: routePois,
      checkpoints: checkpoints,
      userQuestion: userQuestion,
    );

    final systemPrompt = '''
You are a friendly convoy tour guide helping drivers and passengers on a group road trip.

Your role:
- Answer using ONLY the journey, checkpoint, and route-place data below.
- Never invent restaurants, fuel stations, viewpoints, or addresses.
- Prefer places marked near start, mid-route, or near destination when giving directions.
- Mention planned convoy checkpoints when they are relevant to the question.
- Keep answers concise and practical for people actively driving.
- Use bullet points when listing multiple options.

$routeContext
''';

    final sanitizedHistory = _sanitizeHistory(history);
    final contents = <Content>[];

    for (final msg in sanitizedHistory) {
      if (msg.role == 'user') {
        contents.add(Content.text(msg.content));
      } else {
        contents.add(Content.model([TextPart(msg.content)]));
      }
    }
    contents.add(Content.text(userQuestion));

    Object? lastError;
    for (final modelName in _modelFallbackChain) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: ApiKeys.geminiApiKey,
          systemInstruction: Content.system(systemPrompt),
          generationConfig: GenerationConfig(
            temperature: 0.35,
            maxOutputTokens: 900,
          ),
        );

        final response = await model.generateContent(contents);

        final blockReason = response.promptFeedback?.blockReason;
        if (blockReason != null) {
          throw RouteAssistantException(
            'Response blocked by safety filters ($blockReason).',
          );
        }

        final text = response.text?.trim();
        if (text != null && text.isNotEmpty) {
          return text;
        }

        throw const RouteAssistantException('Empty response from Gemini.');
      } on GenerativeAIException catch (e) {
        lastError = e;
        final message = e.message.toLowerCase();
        if (message.contains('not found') || message.contains('404')) {
          continue;
        }
        throw _mapGenerativeAiError(e);
      } on RouteAssistantException {
        rethrow;
      } catch (e) {
        lastError = e;
        continue;
      }
    }

    if (lastError is GenerativeAIException) {
      throw _mapGenerativeAiError(lastError);
    }
    throw RouteAssistantException(
      'All Gemini models failed. Check your API key and network connection.',
    );
  }

  List<ChatMessageEntity> _sanitizeHistory(List<ChatMessageEntity> history) {
    return history.where((msg) {
      if (msg.content == 'Thinking...') return false;
      if (msg.role == 'assistant' &&
          (msg.content.startsWith('Failed to connect') ||
              msg.content.startsWith('📍 Using local route guide') ||
              msg.content.startsWith('Sorry, I could not answer'))) {
        return false;
      }
      return true;
    }).toList();
  }

  RouteAssistantException _mapGenerativeAiError(GenerativeAIException e) {
    final message = e.message.toLowerCase();
    if (message.contains('api key') ||
        message.contains('invalid') ||
        message.contains('permission')) {
      return const RouteAssistantException(
        'Invalid Gemini API key. Get a free key at aistudio.google.com/apikey',
        isRetryable: false,
      );
    }
    if (message.contains('quota') || message.contains('rate')) {
      return const RouteAssistantException(
        'Gemini API quota exceeded. Try again later or use local fallback.',
      );
    }
    return RouteAssistantException('Gemini error: ${e.message}');
  }
}
