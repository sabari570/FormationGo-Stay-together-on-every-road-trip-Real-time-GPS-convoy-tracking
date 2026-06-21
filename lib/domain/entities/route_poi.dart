class RoutePoiEntity {
  final String id;
  final String journeyId;
  final String name;
  final String category;
  final String tags;
  final double latitude;
  final double longitude;
  final double? rating;
  final String? address;
  final String source;
  final DateTime fetchedAt;

  const RoutePoiEntity({
    required this.id,
    required this.journeyId,
    required this.name,
    required this.category,
    required this.tags,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.address,
    required this.source,
    required this.fetchedAt,
  });
}
