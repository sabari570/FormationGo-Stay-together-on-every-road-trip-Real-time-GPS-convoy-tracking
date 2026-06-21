import '../entities/group_message.dart';

abstract class GroupChatRepository {
  Stream<List<GroupMessageEntity>> watchMessages(
    String journeyId,
    String passCode,
  );

  Future<void> sendMessage({
    required String journeyId,
    required String passCode,
    required String senderDeviceId,
    required String senderName,
    required String senderAvatarColor,
    required String content,
  });
}
