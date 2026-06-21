class GroupMessageEntity {
  final String id;
  final String journeyId;
  final String senderDeviceId;
  final String senderName;
  final String senderAvatarColor;
  final String content;
  final DateTime createdAt;
  final bool decryptFailed;

  const GroupMessageEntity({
    required this.id,
    required this.journeyId,
    required this.senderDeviceId,
    required this.senderName,
    required this.senderAvatarColor,
    required this.content,
    required this.createdAt,
    this.decryptFailed = false,
  });
}
