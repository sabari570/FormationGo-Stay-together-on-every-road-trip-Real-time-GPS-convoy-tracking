import '../../../domain/entities/journey.dart';
import '../../../domain/entities/route_poi.dart';
import 'route_context_builder.dart';

/// Filters route POIs by keywords in the user's question.
List<RoutePoiEntity> filterPoisForQuestion(
  List<RoutePoiEntity> pois,
  String question, {
  int limit = 25,
}) {
  if (pois.isEmpty) return [];

  final queryLower = question.toLowerCase();
  var filtered = List<RoutePoiEntity>.from(pois);

  if (_matchesAny(queryLower, [
    'food',
    'eat',
    'restaurant',
    'cafe',
    'coffee',
    'lunch',
    'dinner',
    'breakfast',
    'hungry',
    'meal',
  ])) {
    filtered = pois
        .where((p) =>
            p.category == 'restaurant' ||
            p.category == 'cafe' ||
            p.category == 'fast_food')
        .toList();
  } else if (_matchesAny(queryLower, [
    'nature',
    'view',
    'park',
    'scenic',
    'waterfall',
    'sightseeing',
    'attraction',
    'photo',
    'landscape',
  ])) {
    filtered = pois
        .where((p) =>
            p.category == 'nature' ||
            p.category == 'scenic' ||
            p.category == 'attraction')
        .toList();
  } else if (_matchesAny(queryLower, [
    'fuel',
    'gas',
    'petrol',
    'diesel',
    'bunk',
    'pump',
    'refuel',
  ])) {
    filtered = pois.where((p) => p.category == 'fuel').toList();
  } else if (_matchesAny(queryLower, [
    'hotel',
    'stay',
    'lodge',
    'sleep',
    'motel',
    'overnight',
  ])) {
    filtered = pois
        .where((p) => p.category == 'rest_area' || p.category == 'hotel')
        .toList();
  } else if (_matchesAny(queryLower, [
    'rest',
    'break',
    'stop',
    'toilet',
    'bathroom',
    'washroom',
    'stretch',
  ])) {
    filtered = pois
        .where((p) =>
            p.category == 'rest_area' ||
            p.category == 'nature' ||
            p.category == 'scenic')
        .toList();
  }

  if (filtered.isEmpty) {
    filtered = pois;
  }

  return filtered.take(limit).toList();
}

bool _matchesAny(String query, List<String> keywords) {
  for (final keyword in keywords) {
    if (query.contains(keyword)) return true;
  }
  return false;
}

String formatPoiContextLines(
  List<RoutePoiEntity> pois, {
  JourneyEntity? journey,
}) {
  return pois.map((poi) {
    final segment =
        journey != null ? describeRouteSegment(poi, journey) : 'along route';
    final detail = extractPoiDetail(poi.tags);
    final detailStr = detail != null ? ' | $detail' : '';
    final address = poi.address ?? 'Along route';
    return '- ${poi.name} [${poi.category}] ($segment) at '
        '(${poi.latitude.toStringAsFixed(4)}, ${poi.longitude.toStringAsFixed(4)})'
        ' | $address$detailStr';
  }).join('\n');
}
