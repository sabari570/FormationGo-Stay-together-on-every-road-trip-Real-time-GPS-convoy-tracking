import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/database/app_database.dart';

class OverpassService {
  final Dio _dio;
  static const _url = 'https://overpass-api.de/api/interpreter';

  OverpassService(this._dio);

  Future<List<RoutePoi>> fetchNaturePois({
    required LatLng center,
    required String journeyId,
    double radiusKm = 8.0,
  }) async {
    final results = <RoutePoi>[];
    final radiusMeters = radiusKm * 1000;

    // Overpass QL query searching for scenic/nature amenities
    final query = '''
      [out:json][timeout:25];
      (
        node["tourism"="viewpoint"](around:$radiusMeters,${center.latitude},${center.longitude});
        node["natural"="waterfall"](around:$radiusMeters,${center.latitude},${center.longitude});
        node["leisure"="park"](around:$radiusMeters,${center.latitude},${center.longitude});
        node["tourism"="picnic_site"](around:$radiusMeters,${center.latitude},${center.longitude});
      );
      out body;
    ''';

    try {
      final response = await _dio.post(
        _url,
        data: 'data=${Uri.encodeComponent(query)}',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null && response.data['elements'] != null) {
        final elements = response.data['elements'] as List;
        for (final element in elements) {
          final id = 'osm_${element['id']}';
          final tags = element['tags'] as Map<String, dynamic>? ?? {};
          final name = tags['name'] ?? tags['description'] ?? 'Scenic Spot';
          final lat = (element['lat'] as num).toDouble();
          final lng = (element['lon'] as num).toDouble();

          final tagsJson = jsonEncode(tags);

          results.add(
            RoutePoi(
              id: id,
              journeyId: journeyId,
              name: name,
              category: 'nature',
              tags: tagsJson,
              latitude: lat,
              longitude: lng,
              rating: null,
              address: tags['addr:full'] ?? tags['addr:street'] ?? 'Scenic Route',
              source: 'openstreetmap',
              fetchedAt: DateTime.now(),
            ),
          );
        }
      }
    } catch (e) {
      print('OverpassService error: $e');
    }

    return results;
  }
}
