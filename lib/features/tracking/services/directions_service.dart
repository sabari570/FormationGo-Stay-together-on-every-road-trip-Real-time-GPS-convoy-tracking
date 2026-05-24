import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_keys.dart';

class DirectionsService {
  Future<List<LatLng>> getRouteCoordinates(
    double startLat,
    double startLng,
    double destLat,
    double destLng,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$destLat,$destLng&key=${ApiKeys.googleMaps}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            final polylineEncoded = routes[0]['overview_polyline']['points'] as String;
            return _decodePolyline(polylineEncoded);
          }
        }
      }
    } catch (e) {
      // Log or handle error
    }
    return [];
  }

  List<LatLng> _decodePolyline(String poly) {
    var list = <LatLng>[];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      list.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return list;
  }
}
