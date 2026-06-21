import 'dart:convert';
import 'dart:math' as math;

import '../../../domain/entities/checkpoint.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/route_poi.dart';
import 'poi_query_utils.dart';

/// Builds structured route context for the tour-guide AI and local fallback.
class RouteContextBuilder {
  const RouteContextBuilder._();

  static String buildSystemContext({
    required JourneyEntity journey,
    required List<RoutePoiEntity> routePois,
    required List<CheckpointEntity> checkpoints,
    required String userQuestion,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('JOURNEY OVERVIEW');
    buffer.writeln('- Trip: ${journey.name}');
    buffer.writeln(
      '- Route: ${_formatPlace(journey.sourceName, journey.sourceLat, journey.sourceLng)}'
      ' → ${_formatPlace(journey.destinationName, journey.destinationLat, journey.destinationLng)}',
    );

    final routeKm = _estimateRouteKm(journey);
    if (routeKm != null) {
      buffer.writeln('- Estimated driving distance: ~${routeKm.round()} km');
    }

    if (checkpoints.isNotEmpty) {
      buffer.writeln('\nPLANNED CONVOY CHECKPOINTS (confirmed stops on this trip):');
      for (final cp in checkpoints) {
        buffer.writeln(
          '- ${cp.name} [${cp.type}] at (${cp.latitude.toStringAsFixed(4)}, ${cp.longitude.toStringAsFixed(4)}) | radius ${cp.radius.round()}m',
        );
      }
    } else {
      buffer.writeln('\nPLANNED CONVOY CHECKPOINTS: none added yet.');
    }

    buffer.writeln('\nPLACES ALONG ROUTE (OpenStreetMap data, sorted start → destination):');
    if (routePois.isEmpty) {
      buffer.writeln(
        'No mapped places were found along this route corridor. '
        'Answer using journey overview and checkpoints only.',
      );
    } else {
      final sorted = sortPoisAlongRoute(routePois, journey);
      final filtered = filterPoisForQuestion(sorted, userQuestion, limit: 35);
      buffer.write(formatPoiContextLines(filtered, journey: journey));
    }

    return buffer.toString();
  }

  static String buildLocalReply({
    required JourneyEntity journey,
    required List<RoutePoiEntity> routePois,
    required List<CheckpointEntity> checkpoints,
    required String userQuestion,
  }) {
    final from = journey.sourceName ?? 'your starting point';
    final to = journey.destinationName ?? 'your destination';

    if (routePois.isEmpty && checkpoints.isEmpty) {
      return 'I could not find mapped stops along $from → $to yet. '
          'Try asking about your planned checkpoints or general route info.';
    }

    final buffer = StringBuffer()
      ..writeln('Along your route from $from to $to:\n');

    var addedContent = false;

    if (checkpoints.isNotEmpty &&
        _questionMentionsCheckpoints(userQuestion)) {
      buffer.writeln('Planned checkpoints:');
      for (final cp in checkpoints) {
        buffer.writeln('• ${cp.name} (${cp.type})');
      }
      buffer.writeln('');
      addedContent = true;
    }

    if (routePois.isNotEmpty) {
      final sorted = sortPoisAlongRoute(routePois, journey);
      final matches = filterPoisForQuestion(sorted, userQuestion, limit: 5);
      if (matches.isNotEmpty) {
        buffer.writeln('Suggested stops:');
        for (final poi in matches) {
          final segment = describeRouteSegment(poi, journey);
          final address = poi.address ?? 'Along route';
          buffer.writeln(
            '• ${poi.name} (${poi.category}, $segment) — $address',
          );
        }
        addedContent = true;
      }
    }

    if (!addedContent) {
      return 'I could not find matching stops for that question. '
          'Try asking about food, fuel, scenic views, rest areas, or checkpoints.';
    }

    return buffer.toString();
  }

  static bool _questionMentionsCheckpoints(String question) {
    final q = question.toLowerCase();
    return q.contains('checkpoint') ||
        q.contains('stop') ||
        q.contains('meet') ||
        q.contains('planned');
  }

  static String _formatPlace(String? name, double? lat, double? lng) {
    final label = name ?? 'Unknown';
    if (lat == null || lng == null) return label;
    return '$label (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})';
  }

  static double? _estimateRouteKm(JourneyEntity journey) {
    if (journey.sourceLat == null ||
        journey.sourceLng == null ||
        journey.destinationLat == null ||
        journey.destinationLng == null) {
      return null;
    }
    final straight = _haversineKm(
      journey.sourceLat!,
      journey.sourceLng!,
      journey.destinationLat!,
      journey.destinationLng!,
    );
    return straight * 1.25;
  }

  static double haversineKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371.0;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLng = _degreesToRadians(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static double _haversineKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) =>
      haversineKm(lat1, lng1, lat2, lng2);

  static double _degreesToRadians(double degrees) => degrees * math.pi / 180;
}

/// Sort POIs from journey start toward destination.
List<RoutePoiEntity> sortPoisAlongRoute(
  List<RoutePoiEntity> pois,
  JourneyEntity journey,
) {
  if (pois.length <= 1 ||
      journey.sourceLat == null ||
      journey.sourceLng == null) {
    return pois;
  }

  final startLat = journey.sourceLat!;
  final startLng = journey.sourceLng!;

  final sorted = List<RoutePoiEntity>.from(pois);
  sorted.sort((a, b) {
    final distA = RouteContextBuilder.haversineKm(
      startLat,
      startLng,
      a.latitude,
      a.longitude,
    );
    final distB = RouteContextBuilder.haversineKm(
      startLat,
      startLng,
      b.latitude,
      b.longitude,
    );
    return distA.compareTo(distB);
  });
  return sorted;
}

String describeRouteSegment(RoutePoiEntity poi, JourneyEntity journey) {
  if (journey.sourceLat == null ||
      journey.sourceLng == null ||
      journey.destinationLat == null ||
      journey.destinationLng == null) {
    return 'along route';
  }

  final total = RouteContextBuilder.haversineKm(
    journey.sourceLat!,
    journey.sourceLng!,
    journey.destinationLat!,
    journey.destinationLng!,
  );
  if (total <= 0) return 'along route';

  final fromStart = RouteContextBuilder.haversineKm(
    journey.sourceLat!,
    journey.sourceLng!,
    poi.latitude,
    poi.longitude,
  );
  final ratio = fromStart / total;

  if (ratio <= 0.25) return 'near start';
  if (ratio >= 0.75) return 'near destination';
  return 'mid-route';
}

String? extractPoiDetail(String tagsJson) {
  try {
    final tags = jsonDecode(tagsJson) as Map<String, dynamic>;
    final parts = <String>[];
    final cuisine = tags['cuisine'];
    if (cuisine is String && cuisine.isNotEmpty) {
      parts.add('cuisine: $cuisine');
    }
    final opening = tags['opening_hours'];
    if (opening is String && opening.isNotEmpty) {
      parts.add('hours: $opening');
    }
    final wheelchair = tags['wheelchair'];
    if (wheelchair is String && wheelchair.isNotEmpty) {
      parts.add('wheelchair: $wheelchair');
    }
    return parts.isEmpty ? null : parts.join(', ');
  } catch (_) {
    return null;
  }
}
