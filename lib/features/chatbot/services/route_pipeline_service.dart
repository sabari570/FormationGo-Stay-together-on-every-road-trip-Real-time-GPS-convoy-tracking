import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import '../models/route_poi_indexing_state.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/repositories/route_poi_repository.dart';
import 'overpass_service.dart';
import '../../../domain/entities/route_poi.dart';

typedef RoutePoiPipelineListener = void Function(
  String journeyId,
  RoutePoiIndexingState state,
);

class RoutePipelineService {
  final RoutePoiRepository _poiRepository;
  final OverpassService _overpassService;
  final Set<String> _activeJourneys = {};

  RoutePoiPipelineListener? onStatusChanged;

  RoutePipelineService(this._poiRepository, this._overpassService);

  Future<void> initializeForJourney(
    JourneyEntity journey, {
    List<LatLng>? routeCoordinates,
    bool force = false,
  }) async {
    if (journey.sourceLat == null ||
        journey.sourceLng == null ||
        journey.destinationLat == null ||
        journey.destinationLng == null) {
      return;
    }

    if (_activeJourneys.contains(journey.id)) return;
    if (!force && await _poiRepository.hasPois(journey.id)) {
      onStatusChanged?.call(journey.id, RoutePoiIndexingState.ready);
      return;
    }

    _activeJourneys.add(journey.id);
    onStatusChanged?.call(journey.id, RoutePoiIndexingState.indexing);

    try {
      await _fetchAndCachePois(journey, routeCoordinates);
      final hasPois = await _poiRepository.hasPois(journey.id);
      onStatusChanged?.call(
        journey.id,
        hasPois ? RoutePoiIndexingState.ready : RoutePoiIndexingState.failed,
      );
    } catch (_) {
      onStatusChanged?.call(journey.id, RoutePoiIndexingState.failed);
    } finally {
      _activeJourneys.remove(journey.id);
    }
  }

  Future<void> _fetchAndCachePois(
    JourneyEntity journey,
    List<LatLng>? routeCoordinates,
  ) async {
    final coordinates = routeCoordinates ?? <LatLng>[];
    final resolvedCoordinates = coordinates.isNotEmpty
        ? coordinates
        : <LatLng>[
            LatLng(journey.sourceLat!, journey.sourceLng!),
            LatLng(journey.destinationLat!, journey.destinationLng!),
          ];

    final sampledPoints = _samplePoints(resolvedCoordinates, targetCount: 4);
    if (sampledPoints.isEmpty) return;

    final seenIds = <String>{};

    for (var i = 0; i < sampledPoints.length; i++) {
      if (i > 0) {
        await Future.delayed(const Duration(seconds: 2));
      }

      final pois = await _overpassService.fetchPoisAtPoint(
        center: sampledPoints[i],
        journeyId: journey.id,
      );
      final unique = _dedupePois(pois, seenIds);
      if (unique.isNotEmpty) {
        await _poiRepository.savePois(unique);
      }
    }
  }

  List<RoutePoiEntity> _dedupePois(
    List<RoutePoiEntity> pois,
    Set<String> seenIds,
  ) {
    final unique = <RoutePoiEntity>[];
    for (final poi in pois) {
      if (seenIds.add(poi.id)) {
        unique.add(poi);
      }
    }
    return unique;
  }

  List<LatLng> _samplePoints(List<LatLng> points, {int targetCount = 4}) {
    if (points.length <= targetCount) return points;

    final result = <LatLng>[];
    result.add(points.first);

    final interval = points.length / (targetCount - 1);
    for (int i = 1; i < targetCount - 1; i++) {
      final index = (i * interval).round();
      if (index > 0 && index < points.length - 1) {
        result.add(points[index]);
      }
    }

    result.add(points.last);

    final filtered = <LatLng>[];
    for (final point in result) {
      var isTooClose = false;
      for (final selected in filtered) {
        if (_distanceInKm(point, selected) < 10.0) {
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
    const earthRadius = 6371.0;
    final dLat = _degreesToRadians(p2.latitude - p1.latitude);
    final dLng = _degreesToRadians(p2.longitude - p1.longitude);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(p1.latitude)) *
            math.cos(_degreesToRadians(p2.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;
}
