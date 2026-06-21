import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> getMessages(String journeyId);
  Stream<List<ChatMessageEntity>> watchMessages(String journeyId);
  Future<void> saveMessage(ChatMessageEntity message);
  Future<void> clearMessages(String journeyId);
}
