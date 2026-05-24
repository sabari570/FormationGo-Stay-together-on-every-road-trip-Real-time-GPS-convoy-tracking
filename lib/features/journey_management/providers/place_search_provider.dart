import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/api_keys.dart';

part 'place_search_provider.g.dart';

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({
    required this.description,
    required this.placeId,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
    );
  }
}

class PlaceDetails {
  final String name;
  final double latitude;
  final double longitude;

  PlaceDetails({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

@riverpod
class PlaceSearch extends _$PlaceSearch {
  @override
  AsyncValue<List<PlacePrediction>> build() {
    return const AsyncValue.data([]);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=${ApiKeys.googleMaps}',
      );

      final response = await http.get(url);
      // ignore: avoid_print
      print('[PlaceSearch] autocomplete status=${response.statusCode} body=${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = (data['predictions'] as List)
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
          state = AsyncValue.data(predictions);
        } else if (data['status'] == 'ZERO_RESULTS') {
          state = const AsyncValue.data([]);
        } else {
          state = AsyncValue.error(
            Exception('Places API Error: ${data['status']} - ${data['error_message'] ?? ""}'),
            StackTrace.current,
          );
        }
      } else {
        state = AsyncValue.error(
          Exception('Failed to load predictions: ${response.statusCode}'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<PlaceDetails> getDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,geometry&key=${ApiKeys.googleMaps}',
    );

    final response = await http.get(url);
    // Debug: log the raw response so we can diagnose API errors
    // ignore: avoid_print
    print('[PlaceSearch] getDetails status=${response.statusCode} body=${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Network error: HTTP ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final status = data['status'] as String;

    if (status != 'OK') {
      final msg = data['error_message'] as String? ?? status;
      throw Exception('Places API error: $msg');
    }

    final result = data['result'] as Map<String, dynamic>;
    final name = result['name'] as String;
    final location = (result['geometry'] as Map<String, dynamic>)['location'] as Map<String, dynamic>;
    final lat = (location['lat'] as num).toDouble();
    final lng = (location['lng'] as num).toDouble();

    return PlaceDetails(
      name: name,
      latitude: lat,
      longitude: lng,
    );
  }
}
