import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/chat_message.dart';
import 'firestore_mapper.dart';

class FirestoreChatDatasource {
  final FirebaseFirestore _firestore;

  FirestoreChatDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _messages(String journeyId) =>
      _firestore
          .collection('journeys')
          .doc(journeyId)
          .collection('chat_messages');

  Future<List<ChatMessageEntity>> getMessages(String journeyId) async {
    final snapshot = await _messages(journeyId)
        .orderBy('createdAt', descending: false)
        .get();
    return snapshot.docs.map(_fromMap).toList();
  }

  Stream<List<ChatMessageEntity>> watchMessages(String journeyId) {
    return _messages(journeyId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromMap).toList());
  }

  Future<void> saveMessage(ChatMessageEntity message) async {
    await _messages(message.journeyId).doc(message.id).set({
      'id': message.id,
      'journeyId': message.journeyId,
      'role': message.role,
      'content': message.content,
      'createdAt': message.createdAt.toIso8601String(),
    });
  }

  Future<void> clearMessages(String journeyId) async {
    final snapshot = await _messages(journeyId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  ChatMessageEntity _fromMap(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return ChatMessageEntity(
      id: data['id'] as String? ?? doc.id,
      journeyId: data['journeyId'] as String,
      role: data['role'] as String,
      content: data['content'] as String,
      createdAt: FirestoreMapper.fromTimestamp(data['createdAt']),
    );
  }
}
