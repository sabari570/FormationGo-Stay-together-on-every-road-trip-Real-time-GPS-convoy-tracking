import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../providers/place_search_provider.dart';

class CurrentLocationService {
  Future<PlaceDetails> getCurrentPlace() async {
    await _ensureLocationAvailable();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return placeFromCoordinates(
      position.latitude,
      position.longitude,
    );
  }

  Future<PlaceDetails> placeFromCoordinates(double latitude, double longitude) async {
    final name = await _resolvePlaceName(latitude, longitude);
    return PlaceDetails(
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<PlaceDetails> placeFromLatLng(LatLng latLng) {
    return placeFromCoordinates(latLng.latitude, latLng.longitude);
  }

  Future<void> _ensureLocationAvailable() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied. Please allow location access.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. Please enable it from app settings.',
      );
    }
  }

  Future<String> _resolvePlaceName(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=$latitude&lon=$longitude&format=json',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FormationGo/1.0 (convoy-tracking-app)',
          'Accept-Language': 'en',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;
        if (address != null) {
          final parts = [
            address['road'],
            address['suburb'] ?? address['neighbourhood'],
            address['city'] ?? address['town'] ?? address['village'],
          ].whereType<String>().where((part) => part.isNotEmpty).toList();

          if (parts.isNotEmpty) {
            return parts.take(2).join(', ');
          }
        }

        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          return displayName.split(',').first.trim();
        }
      }
    } catch (_) {
      // Fall back to generic label below.
    }

    return 'Current Location';
  }
}
