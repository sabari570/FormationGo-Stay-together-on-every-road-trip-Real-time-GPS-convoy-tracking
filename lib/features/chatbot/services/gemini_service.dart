import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/constants/api_keys.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/entities/journey.dart';

class GeminiService {
  GeminiService();

  Future<String> askAboutRoute({
    required String userQuestion,
    required List<RoutePoi> routePois,
    required JourneyEntity journey,
    required List<ChatMessage> history,
  }) async {
    // 1. Build a relevant POI context string from cached route POIs
    final poiContext = _buildPoiContext(routePois, userQuestion);

    // 2. System prompt instructing Gemini to act as a premium tour guide for the specific route
    final systemPrompt = '''
You are a friendly, enthusiastic, and knowledgeable convoy tour guide/assistant for a road trip 
from ${journey.sourceName ?? 'Origin'} to ${journey.destinationName ?? 'Destination'}.

Your role:
- Help convoy drivers and passengers find the best places along their exact route.
- Answer questions in a warm, engaging, and highly conversational road-trip guide style.
- Always recommend real places from the ROUTE DATA context below.
- Do NOT hallucinate places that are not in the provided ROUTE DATA.
- If asked about food/dining, mention the restaurant's rating (if available) and style.
- If asked about nature/scenic locations, describe the outdoor, photographic, or scenic vibe.
- Keep responses relatively concise and easy to read (use bullet points or emojis) since users are traveling.

ROUTE DATA (Places fetched along this exact route):
$poiContext
''';

    // 3. Format history and current prompt using Content structures
    final contents = <Content>[];

    // Build history content if any
    for (final msg in history) {
      if (msg.role == 'user') {
        contents.add(Content.text(msg.content));
      } else {
        contents.add(Content.model([TextPart(msg.content)]));
      }
    }

    // Append the system prompt context as part of the user's latest query or model context.
    // In Gemini Generative AI, system instructions are passed to the model or prepended.
    // We can prepend the system prompt context to the user's question or use GenerativeModel systemInstruction.
    // The google_generative_ai package supports setting systemInstruction on creation,
    // but since we want the system instructions to be journey-aware and dynamically constructed,
    // we can create a dynamic GenerativeModel per request, or we can just pass the system instruction as a systemInstruction parameter.

    final dynamicModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: ApiKeys.geminiApiKey,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 800,
      ),
    );

    contents.add(Content.text(userQuestion));

    final response = await dynamicModel.generateContent(contents);
    return response.text ??
        "I'm sorry, I couldn't process your request. Please try again.";
  }

  String _buildPoiContext(List<RoutePoi> pois, String question) {
    if (pois.isEmpty) {
      return "No specific places registered along the route yet.";
    }

    final queryLower = question.toLowerCase();

    // Sort or filter POIs based on search intent to fit nicely in model limits (RAG)
    var filteredPois = List<RoutePoi>.from(pois);
    if (queryLower.contains('food') ||
        queryLower.contains('eat') ||
        queryLower.contains('restaurant') ||
        queryLower.contains('cafe')) {
      filteredPois = pois.where((p) => p.category == 'restaurant').toList();
    } else if (queryLower.contains('nature') ||
        queryLower.contains('view') ||
        queryLower.contains('park') ||
        queryLower.contains('scenic') ||
        queryLower.contains('waterfall')) {
      filteredPois = pois
          .where((p) => p.category == 'nature' || p.category == 'scenic')
          .toList();
    } else if (queryLower.contains('fuel') ||
        queryLower.contains('gas') ||
        queryLower.contains('petrol') ||
        queryLower.contains('diesel')) {
      filteredPois = pois.where((p) => p.category == 'fuel').toList();
    } else if (queryLower.contains('hotel') ||
        queryLower.contains('stay') ||
        queryLower.contains('lodge') ||
        queryLower.contains('rest')) {
      filteredPois = pois
          .where((p) => p.category == 'rest_area' || p.category == 'restaurant')
          .toList();
    }

    // If filtering left us with nothing, fall back to all POIs
    if (filteredPois.isEmpty) {
      filteredPois = pois;
    }

    // Limit context length to top 25 POIs to prevent prompt bloating
    filteredPois = filteredPois.take(25).toList();

    return filteredPois.map((poi) {
      final ratingStr = poi.rating != null ? '${poi.rating} ⭐' : 'N/A';
      return '- ${poi.name} [Category: ${poi.category}] | Rating: $ratingStr | Address: ${poi.address ?? "On route"} | Lat/Lng: (${poi.latitude}, ${poi.longitude})';
    }).join('\n');
  }
}
