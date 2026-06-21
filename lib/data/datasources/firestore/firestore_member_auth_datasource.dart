import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMemberAuthDatasource {
  final FirebaseFirestore _firestore;

  FirestoreMemberAuthDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _memberAuth(String journeyId) =>
      _firestore
          .collection('journeys')
          .doc(journeyId)
          .collection('member_auth');

  Future<void> upsertMemberAuth({
    required String journeyId,
    required String authUid,
    required String deviceId,
    required String name,
    required String avatarColor,
  }) async {
    await _memberAuth(journeyId).doc(authUid).set({
      'authUid': authUid,
      'deviceId': deviceId,
      'name': name,
      'avatarColor': avatarColor,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
