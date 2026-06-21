class MemberLocationEntity {
  final String deviceId;
  final String journeyId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final double accuracy;
  final DateTime timestamp;

  const MemberLocationEntity({
    required this.deviceId,
    required this.journeyId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.accuracy,
    required this.timestamp,
  });
}
