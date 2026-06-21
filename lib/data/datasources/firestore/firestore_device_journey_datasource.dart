import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDeviceJourneyDatasource {
  final FirebaseFirestore _firestore;

  FirestoreDeviceJourneyDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _refs(String deviceId) =>
      _firestore.collection('device_journeys').doc(deviceId).collection('refs');

  Future<void> upsertRef({
    required String deviceId,
    required String journeyId,
    required String role,
  }) async {
    await _refs(deviceId).doc(journeyId).set({
      'journeyId': journeyId,
      'role': role,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeRef({
    required String deviceId,
    required String journeyId,
  }) async {
    await _refs(deviceId).doc(journeyId).delete();
  }

  Future<void> pruneStaleRefs({
    required String deviceId,
    required Future<bool> Function(String journeyId) isJourneyAccessible,
  }) async {
    final snapshot = await _refs(deviceId).get();
    for (final doc in snapshot.docs) {
      final journeyId = doc.data()['journeyId'] as String? ?? doc.id;
      if (journeyId.isEmpty) {
        await doc.reference.delete();
        continue;
      }
      final accessible = await isJourneyAccessible(journeyId);
      if (!accessible) {
        await doc.reference.delete();
      }
    }
  }

  Stream<List<String>> watchJourneyIds({
    required String deviceId,
    required String role,
  }) {
    return _refs(deviceId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .where((doc) => doc.data()['role'] == role)
              .map((doc) => doc.data()['journeyId'] as String? ?? doc.id)
              .where((id) => id.isNotEmpty)
              .toList();
        })
        .handleError((_, __) => <String>[]);
  }
}
