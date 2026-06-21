import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/firestore/firestore_chat_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirestoreChatDatasource _datasource;

  ChatRepositoryImpl(this._datasource);

  @override
  Future<List<ChatMessageEntity>> getMessages(String journeyId) =>
      _datasource.getMessages(journeyId);

  @override
  Stream<List<ChatMessageEntity>> watchMessages(String journeyId) =>
      _datasource.watchMessages(journeyId);

  @override
  Future<void> saveMessage(ChatMessageEntity message) =>
      _datasource.saveMessage(message);

  @override
  Future<void> clearMessages(String journeyId) =>
      _datasource.clearMessages(journeyId);
}
