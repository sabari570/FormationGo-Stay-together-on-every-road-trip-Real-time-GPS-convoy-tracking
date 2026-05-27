import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_provider.g.dart';

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({
    required this.description,
    required this.placeId,
  });
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
  // In-memory cache: populated during search so getDetails is instant (no 2nd request)
  final Map<String, PlaceDetails> _detailsCache = {};

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
      // Nominatim OpenStreetMap – free, no billing required
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&limit=7'
        '&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        // Nominatim requires a meaningful User-Agent
        'User-Agent': 'FormationGo/1.0 (convoy-tracking-app)',
        'Accept-Language': 'en',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final predictions = <PlacePrediction>[];

        for (final item in data) {
          final placeId = item['place_id'].toString();
          final displayName = item['display_name'] as String;
          final lat = double.parse(item['lat'] as String);
          final lon = double.parse(item['lon'] as String);

          // Cache lat/lon immediately so getDetails is O(1)
          _detailsCache[placeId] = PlaceDetails(
            name: displayName.split(',').first.trim(),
            latitude: lat,
            longitude: lon,
          );

          predictions.add(PlacePrediction(
            description: displayName,
            placeId: placeId,
          ));
        }

        state = AsyncValue.data(predictions);
      } else {
        state = AsyncValue.error(
          Exception('Geocoding request failed: HTTP ${response.statusCode}'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Returns details from the in-memory cache (always populated during search).
  /// Falls back to a Nominatim lookup if the cache is somehow cold.
  Future<PlaceDetails> getDetails(String placeId) async {
    if (_detailsCache.containsKey(placeId)) {
      return _detailsCache[placeId]!;
    }

    // Fallback: reverse-lookup via Nominatim details endpoint
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/details'
      '?place_id=$placeId'
      '&format=json',
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'FormationGo/1.0 (convoy-tracking-app)',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final centroid = data['centroid'] as Map<String, dynamic>?;
      final coordinates = centroid?['coordinates'] as List<dynamic>?;
      if (coordinates != null && coordinates.length >= 2) {
        final lon = (coordinates[0] as num).toDouble();
        final lat = (coordinates[1] as num).toDouble();
        final localname = data['localname'] as String? ?? 'Location';
        return PlaceDetails(name: localname, latitude: lat, longitude: lon);
      }
    }

    throw Exception('Could not resolve place details. Please try searching again.');
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}
