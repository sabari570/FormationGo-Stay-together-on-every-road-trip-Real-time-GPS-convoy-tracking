import 'dart:math' as math;
import 'package:drift/drift.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/entities/journey.dart';
import '../../tracking/services/directions_service.dart';
import 'places_service.dart';
import 'overpass_service.dart';

class RoutePipelineService {
  final AppDatabase _db;
  final PlacesService _placesService;
  final OverpassService _overpassService;
  final DirectionsService _directionsService = DirectionsService();

  RoutePipelineService(this._db, this._placesService, this._overpassService);

  /// Initializes the background pipeline for a specific journey.
  /// Decodes routes, samples waypoints, parallel fetches POIs, and caches them.
  Future<void> initializeForJourney(JourneyEntity journey) async {
    if (journey.sourceLat == null ||
        journey.sourceLng == null ||
        journey.destinationLat == null ||
        journey.destinationLng == null) {
      return;
    }

    // Check if POIs are already cached in local SQLite to avoid redundant API requests
    final existing = await (_db.select(_db.routePois)..where((t) => t.journeyId.equals(journey.id))).get();
    if (existing.isNotEmpty) {
      print('RoutePipelineService: ${existing.length} POIs are already cached for journey ${journey.id}. Skipping fetch.');
      return;
    }

    // 1. Fetch route coordinates from Directions API
    final coordinates = await _directionsService.getRouteCoordinates(
      journey.sourceLat!,
      journey.sourceLng!,
      journey.destinationLat!,
      journey.destinationLng!,
    );

    if (coordinates.isEmpty) {
      // Fallback: If Directions API fails, just sample start and end points
      coordinates.add(LatLng(journey.sourceLat!, journey.sourceLng!));
      coordinates.add(LatLng(journey.destinationLat!, journey.destinationLng!));
    }

    // 2. Sample coordinates along the route (every ~15-20km, or ~5-8 points along the way)
    final sampledPoints = _samplePoints(coordinates, targetCount: 6);

    // 3. Parallel fetch from Google Places and OpenStreetMap (Overpass)
    final futures = <Future<List<RoutePoi>>>[];
    for (final point in sampledPoints) {
      futures.add(_placesService.fetchNearby(center: point, journeyId: journey.id));
      futures.add(_overpassService.fetchNaturePois(center: point, journeyId: journey.id));
    }

    // Resolve all parallel tasks
    final poiLists = await Future.wait(futures);

    // 4. Flatten lists and batch insert into SQLite database
    final allPois = poiLists.expand((list) => list).toList();
    
    // Batch save POIs into database
    await _db.batch((batch) {
      for (final poi in allPois) {
        batch.insert(
          _db.routePois,
          poi,
          mode: InsertMode.insertOrReplace,
        );
      }
    });

    print('RoutePipelineService: Successfully cached ${allPois.length} POIs for journey ${journey.id}');
  }

  /// Helper to sample coordinates so we cover the route without spamming API calls
  List<LatLng> _samplePoints(List<LatLng> points, {int targetCount = 6}) {
    if (points.length <= targetCount) return points;

    final result = <LatLng>[];
    result.add(points.first); // Always include start point

    final interval = points.length / (targetCount - 1);
    for (int i = 1; i < targetCount - 1; i++) {
      final index = (i * interval).round();
      if (index > 0 && index < points.length - 1) {
        result.add(points[index]);
      }
    }

    result.add(points.last); // Always include end point

    // De-duplicate closely located sampled points (within 5km of each other)
    final filtered = <LatLng>[];
    for (final point in result) {
      bool isTooClose = false;
      for (final selected in filtered) {
        if (_distanceInKm(point, selected) < 8.0) {
          isTooClose = true;
          break;
        }
      }
      if (!isTooClose) {
        filtered.add(point);
      }
    }

    return filtered;
  }

  double _distanceInKm(LatLng p1, LatLng p2) {
    const double earthRadius = 6371; // In kilometers
    final double dLat = _degreesToRadians(p2.latitude - p1.latitude);
    final double dLng = _degreesToRadians(p2.longitude - p1.longitude);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(p1.latitude)) *
            math.cos(_degreesToRadians(p2.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
