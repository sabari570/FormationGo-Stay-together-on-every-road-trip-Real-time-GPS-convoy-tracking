import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../core/constants/map_constants.dart';

class DirectionsService {
  Future<List<LatLng>> getRouteCoordinates(
    double startLat,
    double startLng,
    double destLat,
    double destLng,
  ) async {
    // OSRM expects coordinates as lng,lat
    final url = Uri.parse(
      '${MapConstants.osrmBaseUrl}/route/v1/driving/'
      '$startLng,$startLat;$destLng,$destLat'
      '?overview=full&geometries=polyline',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['code'] == 'Ok') {
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            final polylineEncoded = routes[0]['geometry'] as String;
            return _decodePolyline(polylineEncoded);
          }
        }
      }
    } catch (_) {
      // Caller handles empty fallback.
    }
    return [];
  }

  List<LatLng> _decodePolyline(String poly) {
    final list = <LatLng>[];
    var index = 0;
    final len = poly.length;
    var lat = 0;
    var lng = 0;

    while (index < len) {
      var shift = 0;
      var result = 0;
      int b;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      list.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return list;
  }
}
