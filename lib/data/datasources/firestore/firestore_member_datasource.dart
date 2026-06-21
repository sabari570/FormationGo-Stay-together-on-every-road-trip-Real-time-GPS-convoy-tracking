import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/journey_member.dart';
import 'firestore_mapper.dart';

class FirestoreMemberDatasource {
  final FirebaseFirestore _firestore;

  FirestoreMemberDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _members(String journeyId) =>
      _firestore.collection('journeys').doc(journeyId).collection('members');

  Future<void> addMember(JourneyMemberEntity member) async {
    await _members(member.journeyId).doc(member.deviceId).set({
      'id': member.id,
      'journeyId': member.journeyId,
      'deviceId': member.deviceId,
      'role': member.role,
      'name': member.name,
      'avatarColor': member.avatarColor,
      'joinTime': member.joinTime.toIso8601String(),
    });
  }

  Future<List<JourneyMemberEntity>> getMembers(String journeyId) async {
    final snapshot = await _members(journeyId).get();
    return snapshot.docs.map(_fromMap).toList();
  }

  Stream<List<JourneyMemberEntity>> watchMembers(String journeyId) {
    return _members(journeyId).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromMap).toList(),
        );
  }

  JourneyMemberEntity _fromMap(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return JourneyMemberEntity(
      id: data['id'] as String? ?? doc.id,
      journeyId: data['journeyId'] as String,
      deviceId: data['deviceId'] as String? ?? doc.id,
      role: data['role'] as String,
      name: data['name'] as String,
      avatarColor: data['avatarColor'] as String,
      joinTime: FirestoreMapper.fromTimestamp(data['joinTime']),
    );
  }
}
