class JourneyMemberEntity {
  final String id;
  final String journeyId;
  final String deviceId;
  final String role;
  final String name;
  final String avatarColor;
  final DateTime joinTime;

  const JourneyMemberEntity({
    required this.id,
    required this.journeyId,
    required this.deviceId,
    required this.role,
    required this.name,
    required this.avatarColor,
    required this.joinTime,
  });
}
