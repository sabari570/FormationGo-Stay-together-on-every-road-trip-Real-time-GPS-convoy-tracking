import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/api_keys.dart';
import '../../../data/database/app_database.dart';

class PlacesService {
  final Dio _dio;
  static const _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  PlacesService(this._dio);

  Future<List<RoutePoi>> fetchNearby({
    required LatLng center,
    required String journeyId,
    int radiusMeters = 5000,
  }) async {
    // Define essential categories to query
    final types = ['restaurant', 'gas_station', 'lodging', 'tourist_attraction'];
    final results = <RoutePoi>[];

    for (final type in types) {
      try {
        final response = await _dio.get(
          '$_baseUrl/nearbysearch/json',
          queryParameters: {
            'location': '${center.latitude},${center.longitude}',
            'radius': radiusMeters.toString(),
            'type': type,
            'key': ApiKeys.googleMaps,
          },
        );

        if (response.data != null && response.data['results'] != null) {
          final list = response.data['results'] as List;
          for (final item in list) {
            final id = item['place_id'] ?? const Uuid().v4();
            final name = item['name'] ?? 'Unknown Place';
            final geometry = item['geometry'];
            if (geometry == null) continue;
            final location = geometry['location'];
            if (location == null) continue;

            final lat = (location['lat'] as num).toDouble();
            final lng = (location['lng'] as num).toDouble();
            final rating = item['rating'] != null ? (item['rating'] as num).toDouble() : null;
            final address = item['vicinity'] ?? item['formatted_address'];
            
            // Map types to simpler categories
            String category = 'restaurant';
            if (type == 'gas_station') {
              category = 'fuel';
            } else if (type == 'lodging') {
              category = 'rest_area';
            } else if (type == 'tourist_attraction') {
              category = 'scenic';
            }

            final tagsJson = {
              'types': item['types'],
              'price_level': item['price_level'],
              'user_ratings_total': item['user_ratings_total'],
              'open_now': item['opening_hours']?['open_now'],
            }.toString();

            results.add(
              RoutePoi(
                id: id,
                journeyId: journeyId,
                name: name,
                category: category,
                tags: tagsJson,
                latitude: lat,
                longitude: lng,
                rating: rating,
                address: address,
                source: 'google_places',
                fetchedAt: DateTime.now(),
              ),
            );
          }
        }
      } catch (e) {
        // Silently log/ignore single category failure to avoid breaking pipeline
        print('PlacesService error for type $type: $e');
      }
    }

    // De-duplicate items by ID
    final uniqueResults = <String, RoutePoi>{};
    for (final poi in results) {
      uniqueResults[poi.id] = poi;
    }
    return uniqueResults.values.toList();
  }
}
