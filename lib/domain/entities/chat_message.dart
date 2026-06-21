class ChatMessageEntity {
  final String id;
  final String journeyId;
  final String role;
  final String content;
  final DateTime createdAt;

  const ChatMessageEntity({
    required this.id,
    required this.journeyId,
    required this.role,
    required this.content,
    required this.createdAt,
  });
}
