import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/checkpoint.dart';

class FirestoreCheckpointDatasource {
  final FirebaseFirestore _firestore;

  FirestoreCheckpointDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _checkpoints(String journeyId) =>
      _firestore.collection('journeys').doc(journeyId).collection('checkpoints');

  Future<List<CheckpointEntity>> getCheckpoints(String journeyId) async {
    final snapshot = await _checkpoints(journeyId).get();
    return snapshot.docs.map(_fromMap).toList();
  }

  Stream<List<CheckpointEntity>> watchCheckpoints(String journeyId) {
    return _checkpoints(journeyId).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromMap).toList(),
        );
  }

  Future<void> saveCheckpoint(CheckpointEntity checkpoint) async {
    await _checkpoints(checkpoint.journeyId).doc(checkpoint.id).set({
      'id': checkpoint.id,
      'journeyId': checkpoint.journeyId,
      'name': checkpoint.name,
      'latitude': checkpoint.latitude,
      'longitude': checkpoint.longitude,
      'radius': checkpoint.radius,
      'type': checkpoint.type,
    });
  }

  Future<void> deleteCheckpoint(String journeyId, String id) async {
    await _checkpoints(journeyId).doc(id).delete();
  }

  CheckpointEntity _fromMap(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CheckpointEntity(
      id: data['id'] as String? ?? doc.id,
      journeyId: data['journeyId'] as String,
      name: data['name'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      radius: (data['radius'] as num).toDouble(),
      type: data['type'] as String,
    );
  }
}
