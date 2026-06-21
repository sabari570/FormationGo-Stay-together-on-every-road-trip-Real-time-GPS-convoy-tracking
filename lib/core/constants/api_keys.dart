import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static bool get hasGeminiApiKey => geminiApiKey.isNotEmpty;

  static String get anthropicApiKey => dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  static String get openWeatherMap => dotenv.env['OPENWEATHERMAP_KEY'] ?? '';
}
