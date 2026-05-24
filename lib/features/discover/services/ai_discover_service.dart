import 'package:dio/dio.dart';
import '../../../core/constants/api_keys.dart';

class AiDiscoverService {
  final Dio _dio;

  AiDiscoverService(this._dio) {
    _dio.options.headers = {
      'x-api-key': ApiKeys.anthropicApiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    };
  }

  Future<String> getSmartStopsRecommendation(double lat, double lng, double radius) async {
    final prompt = '''
      We are a motorcycle convoy at ($lat, $lng). 
      Suggest 3 ideal rest stops within $radius km, prioritizing places with large parking lots, gas stations, and diners.
    ''';

    try {
      final response = await _dio.post(
        'https://api.anthropic.com/v1/messages',
        data: {
          'model': 'claude-3-haiku-20240307',
          'max_tokens': 1024,
          'messages': [
            {'role': 'user', 'content': prompt}
          ]
        },
      );
      
      return response.data['content'][0]['text'];
    } catch (e) {
      return 'Failed to get AI recommendations: $e';
    }
  }
}
