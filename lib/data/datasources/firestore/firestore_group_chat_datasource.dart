import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_mapper.dart';

class EncryptedGroupMessageRecord {
  final String id;
  final String journeyId;
  final String senderDeviceId;
  final String senderName;
  final String senderAvatarColor;
  final String encryptedContent;
  final String iv;
  final DateTime createdAt;

  const EncryptedGroupMessageRecord({
    required this.id,
    required this.journeyId,
    required this.senderDeviceId,
    required this.senderName,
    required this.senderAvatarColor,
    required this.encryptedContent,
    required this.iv,
    required this.createdAt,
  });
}

class FirestoreGroupChatDatasource {
  final FirebaseFirestore _firestore;

  FirestoreGroupChatDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _messages(String journeyId) =>
      _firestore
          .collection('journeys')
          .doc(journeyId)
          .collection('group_messages');

  Stream<List<EncryptedGroupMessageRecord>> watchEncryptedMessages(
    String journeyId,
  ) {
    return _messages(journeyId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromMap).toList());
  }

  Future<void> saveEncryptedMessage(EncryptedGroupMessageRecord message) async {
    await _messages(message.journeyId).doc(message.id).set({
      'id': message.id,
      'journeyId': message.journeyId,
      'senderDeviceId': message.senderDeviceId,
      'senderName': message.senderName,
      'senderAvatarColor': message.senderAvatarColor,
      'encryptedContent': message.encryptedContent,
      'iv': message.iv,
      'createdAt': message.createdAt.toIso8601String(),
    });
  }

  EncryptedGroupMessageRecord _fromMap(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return EncryptedGroupMessageRecord(
      id: data['id'] as String? ?? doc.id,
      journeyId: data['journeyId'] as String,
      senderDeviceId: data['senderDeviceId'] as String,
      senderName: data['senderName'] as String? ?? 'Member',
      senderAvatarColor: data['senderAvatarColor'] as String? ?? '#2196F3',
      encryptedContent: data['encryptedContent'] as String,
      iv: data['iv'] as String,
      createdAt: FirestoreMapper.fromTimestamp(data['createdAt']),
    );
  }
}
