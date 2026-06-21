import 'package:uuid/uuid.dart';

import '../../core/services/message_encryption_service.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/repositories/group_chat_repository.dart';
import '../datasources/firestore/firestore_group_chat_datasource.dart';

class GroupChatRepositoryImpl implements GroupChatRepository {
  final FirestoreGroupChatDatasource _datasource;
  final MessageEncryptionService _encryption;

  GroupChatRepositoryImpl(this._datasource, this._encryption);

  @override
  Stream<List<GroupMessageEntity>> watchMessages(
    String journeyId,
    String passCode,
  ) {
    return _datasource.watchEncryptedMessages(journeyId).map(
          (records) => records
              .map((record) => _toEntity(record, journeyId, passCode))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String journeyId,
    required String passCode,
    required String senderDeviceId,
    required String senderName,
    required String senderAvatarColor,
    required String content,
  }) async {
    final payload = _encryption.encrypt(
      journeyId: journeyId,
      passCode: passCode,
      plaintext: content,
    );

    await _datasource.saveEncryptedMessage(
      EncryptedGroupMessageRecord(
        id: const Uuid().v4(),
        journeyId: journeyId,
        senderDeviceId: senderDeviceId,
        senderName: senderName,
        senderAvatarColor: senderAvatarColor,
        encryptedContent: payload.ciphertext,
        iv: payload.iv,
        createdAt: DateTime.now(),
      ),
    );
  }

  GroupMessageEntity _toEntity(
    EncryptedGroupMessageRecord record,
    String journeyId,
    String passCode,
  ) {
    try {
      final plaintext = _encryption.decrypt(
        journeyId: journeyId,
        passCode: passCode,
        ciphertext: record.encryptedContent,
        iv: record.iv,
      );
      return GroupMessageEntity(
        id: record.id,
        journeyId: record.journeyId,
        senderDeviceId: record.senderDeviceId,
        senderName: record.senderName,
        senderAvatarColor: record.senderAvatarColor,
        content: plaintext,
        createdAt: record.createdAt,
      );
    } catch (_) {
      return GroupMessageEntity(
        id: record.id,
        journeyId: record.journeyId,
        senderDeviceId: record.senderDeviceId,
        senderName: record.senderName,
        senderAvatarColor: record.senderAvatarColor,
        content: '[Unable to read message]',
        createdAt: record.createdAt,
        decryptFailed: true,
      );
    }
  }
}
