import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/journey.dart';
import 'firestore_mapper.dart';

class FirestoreJourneyDatasource {
  final FirebaseFirestore _firestore;

  FirestoreJourneyDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _journeys =>
      _firestore.collection('journeys');

  DocumentReference<Map<String, dynamic>> _journeyDoc(String id) =>
      _journeys.doc(id);

  Future<JourneyEntity?> getJourney(String id) async {
    final doc = await _journeyDoc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return FirestoreMapper.journeyFromMap(doc.data()!);
  }

  Future<List<JourneyEntity>> getAllJourneys() async {
    final snapshot = await _journeys.get();
    return snapshot.docs
        .map((doc) => FirestoreMapper.journeyFromMap(doc.data()))
        .toList();
  }

  Stream<List<JourneyEntity>> watchJourneys() {
    return _journeys.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => FirestoreMapper.journeyFromMap(doc.data()))
              .toList(),
        );
  }

  Stream<JourneyEntity?> watchJourney(String id) {
    return _journeyDoc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return FirestoreMapper.journeyFromMap(doc.data()!);
    });
  }

  Future<void> saveJourney(JourneyEntity journey) async {
    await _journeyDoc(journey.id).set(
      FirestoreMapper.journeyToMap(journey),
      SetOptions(merge: true),
    );
  }

  Future<void> deleteJourney(String id) async {
    await _journeyDoc(id).delete();
  }

  Future<JourneyEntity?> findByPasscode(String passCode) async {
    final snapshot = await _journeys
        .where('passCode', isEqualTo: passCode)
        .where('status', isEqualTo: JourneyStatus.active.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return FirestoreMapper.journeyFromMap(snapshot.docs.first.data());
  }
}
