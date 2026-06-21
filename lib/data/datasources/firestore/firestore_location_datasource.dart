import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/member_location.dart';
import 'firestore_mapper.dart';

class FirestoreLocationDatasource {
  final FirebaseFirestore _firestore;

  FirestoreLocationDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _locations(String journeyId) =>
      _firestore.collection('journeys').doc(journeyId).collection('locations');

  Future<void> publishLocation(MemberLocationEntity location) async {
    await _locations(location.journeyId).doc(location.deviceId).set({
      'deviceId': location.deviceId,
      'journeyId': location.journeyId,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'speed': location.speed,
      'heading': location.heading,
      'accuracy': location.accuracy,
      'timestamp': location.timestamp.toIso8601String(),
    });
  }

  Stream<List<MemberLocationEntity>> watchLocations(String journeyId) {
    return _locations(journeyId).snapshots().map(
          (snapshot) => snapshot.docs.map(_fromMap).toList(),
        );
  }

  MemberLocationEntity _fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return MemberLocationEntity(
      deviceId: data['deviceId'] as String? ?? doc.id,
      journeyId: data['journeyId'] as String,
      latitude: FirestoreMapper.toDouble(data['latitude']) ?? 0,
      longitude: FirestoreMapper.toDouble(data['longitude']) ?? 0,
      speed: FirestoreMapper.toDouble(data['speed']) ?? 0,
      heading: FirestoreMapper.toDouble(data['heading']) ?? 0,
      accuracy: FirestoreMapper.toDouble(data['accuracy']) ?? 0,
      timestamp: FirestoreMapper.fromTimestamp(data['timestamp']),
    );
  }
}
