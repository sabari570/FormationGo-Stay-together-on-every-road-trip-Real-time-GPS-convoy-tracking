import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/map_constants.dart';
import '../../../domain/entities/route_poi.dart';

class OverpassService {
  final Dio _dio;

  static const _overpassEndpoints = [
    MapConstants.overpassUrl,
    MapConstants.overpassFallbackUrl,
  ];

  OverpassService(this._dio);

  /// Single combined query for amenities and scenic POIs near a route sample point.
  Future<List<RoutePoiEntity>> fetchPoisAtPoint({
    required LatLng center,
    required String journeyId,
    double radiusKm = 6.0,
  }) async {
    final radiusMeters = (radiusKm * 1000).round();
    final lat = center.latitude.toStringAsFixed(6);
    final lng = center.longitude.toStringAsFixed(6);
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="fuel"](around:$radiusMeters,$lat,$lng);
  node["amenity"="restaurant"](around:$radiusMeters,$lat,$lng);
  node["amenity"="fast_food"](around:$radiusMeters,$lat,$lng);
  node["amenity"="cafe"](around:$radiusMeters,$lat,$lng);
  node["tourism"="hotel"](around:$radiusMeters,$lat,$lng);
  node["tourism"="motel"](around:$radiusMeters,$lat,$lng);
  node["tourism"="attraction"](around:$radiusMeters,$lat,$lng);
  node["tourism"="viewpoint"](around:$radiusMeters,$lat,$lng);
  node["natural"="waterfall"](around:$radiusMeters,$lat,$lng);
  node["leisure"="park"](around:$radiusMeters,$lat,$lng);
  node["tourism"="picnic_site"](around:$radiusMeters,$lat,$lng);
);
out body;
''';

    for (final endpoint in _overpassEndpoints) {
      final results = await _runQuery(
        endpoint: endpoint,
        query: query,
        journeyId: journeyId,
        defaultCategory: 'restaurant',
        source: 'openstreetmap',
        defaultAddress: 'Along route',
        mapCategory: _mapCategory,
      );
      if (results.isNotEmpty) return results;
    }

    return const [];
  }

  Future<List<RoutePoiEntity>> fetchNaturePois({
    required LatLng center,
    required String journeyId,
    double radiusKm = 8.0,
  }) {
    return fetchPoisAtPoint(
      center: center,
      journeyId: journeyId,
      radiusKm: radiusKm,
    );
  }

  Future<List<RoutePoiEntity>> fetchAmenityPois({
    required LatLng center,
    required String journeyId,
    double radiusKm = 5.0,
  }) {
    return fetchPoisAtPoint(
      center: center,
      journeyId: journeyId,
      radiusKm: radiusKm,
    );
  }

  Future<List<RoutePoiEntity>> _runQuery({
    required String endpoint,
    required String query,
    required String journeyId,
    required String defaultCategory,
    required String source,
    required String defaultAddress,
    String Function(Map<String, dynamic> tags)? mapCategory,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {'data': query},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'User-Agent': MapConstants.overpassUserAgent,
            'Accept': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      return _parseElements(
        response.data,
        journeyId: journeyId,
        defaultCategory: defaultCategory,
        source: source,
        defaultAddress: defaultAddress,
        mapCategory: mapCategory,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // ignore: avoid_print
      print(
        'OverpassService error ($endpoint, status=$status): ${e.message}',
      );
      return const [];
    } catch (e) {
      // ignore: avoid_print
      print('OverpassService error ($endpoint): $e');
      return const [];
    }
  }

  List<RoutePoiEntity> _parseElements(
    dynamic data, {
    required String journeyId,
    required String defaultCategory,
    required String source,
    required String defaultAddress,
    String Function(Map<String, dynamic> tags)? mapCategory,
  }) {
    final results = <RoutePoiEntity>[];
    if (data == null) return results;

    final Map<String, dynamic> payload;
    if (data is Map<String, dynamic>) {
      payload = data;
    } else if (data is String) {
      payload = jsonDecode(data) as Map<String, dynamic>;
    } else {
      return results;
    }

    final elements = payload['elements'];
    if (elements is! List) return results;

    for (final element in elements) {
      if (element is! Map<String, dynamic>) continue;
      final tags = element['tags'] as Map<String, dynamic>? ?? {};
      final category = mapCategory?.call(tags) ?? defaultCategory;
      final name = _resolveName(tags, category);
      final lat = element['lat'];
      final lng = element['lon'];
      if (lat is! num || lng is! num) continue;

      final address = tags['addr:full'] ??
          tags['addr:street'] ??
          [
            tags['addr:housenumber'],
            tags['addr:street'],
            tags['addr:city'],
          ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

      results.add(
        RoutePoiEntity(
          id: 'osm_${element['id']}',
          journeyId: journeyId,
          name: name,
          category: category,
          tags: jsonEncode(tags),
          latitude: lat.toDouble(),
          longitude: lng.toDouble(),
          rating: null,
          address: address.isEmpty ? defaultAddress : address,
          source: source,
          fetchedAt: DateTime.now(),
        ),
      );
    }

    return results;
  }

  String _resolveName(Map<String, dynamic> tags, String category) {
    final explicit = tags['name'] ?? tags['brand'] ?? tags['description'];
    if (explicit is String && explicit.trim().isNotEmpty) {
      return explicit.trim();
    }
    return _fallbackName(category);
  }

  String _fallbackName(String category) {
    switch (category) {
      case 'fuel':
        return 'Fuel station';
      case 'cafe':
        return 'Cafe';
      case 'fast_food':
        return 'Fast food';
      case 'hotel':
        return 'Hotel';
      case 'attraction':
        return 'Attraction';
      case 'scenic':
        return 'Scenic viewpoint';
      case 'rest_area':
        return 'Rest area';
      case 'nature':
        return 'Nature spot';
      default:
        return 'Restaurant';
    }
  }

  String _mapCategory(Map<String, dynamic> tags) {
    final amenity = tags['amenity'] as String?;
    final tourism = tags['tourism'] as String?;
    final leisure = tags['leisure'] as String?;
    final natural = tags['natural'] as String?;

    if (amenity == 'fuel') return 'fuel';
    if (amenity == 'cafe') return 'cafe';
    if (amenity == 'fast_food') return 'fast_food';
    if (tourism == 'hotel' || tourism == 'motel') return 'hotel';
    if (tourism == 'attraction') return 'attraction';
    if (tourism == 'viewpoint') return 'scenic';
    if (tourism == 'picnic_site') return 'rest_area';
    if (leisure == 'park') return 'nature';
    if (natural == 'waterfall') return 'nature';
    return 'restaurant';
  }
}
