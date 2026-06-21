import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreJoinCodeDatasource {
  final FirebaseFirestore _firestore;

  FirestoreJoinCodeDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _joinCodes =>
      _firestore.collection('join_codes');

  Future<void> saveJoinCode({
    required String passCode,
    required String journeyId,
  }) async {
    await _joinCodes.doc(passCode).set({
      'journeyId': journeyId,
      'active': true,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<String?> resolveJourneyId(String passCode) async {
    final doc = await _joinCodes.doc(passCode).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    if (data['active'] != true) return null;
    return data['journeyId'] as String?;
  }

  Future<void> deactivateJoinCode(String passCode) async {
    await _joinCodes.doc(passCode).update({'active': false});
  }
}
