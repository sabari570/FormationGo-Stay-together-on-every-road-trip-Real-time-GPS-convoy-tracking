class CheckpointEntity {
  final String id;
  final String journeyId;
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final String type; // e.g. 'meetup', 'fuel', 'rest'

  CheckpointEntity({
    required this.id,
    required this.journeyId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.type,
  });
}
