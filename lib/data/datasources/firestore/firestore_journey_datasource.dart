import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/journey.dart';
import 'firestore_device_journey_datasource.dart';
import 'firestore_join_code_datasource.dart';
import 'firestore_mapper.dart';

class FirestoreJourneyDatasource {
  final FirebaseFirestore _firestore;
  final FirestoreJoinCodeDatasource _joinCodeDs;
  final FirestoreDeviceJourneyDatasource _deviceJourneyDs;

  FirestoreJourneyDatasource(
    this._firestore,
    this._joinCodeDs,
    this._deviceJourneyDs,
  );

  CollectionReference<Map<String, dynamic>> get _journeys =>
      _firestore.collection('journeys');

  DocumentReference<Map<String, dynamic>> _journeyDoc(String id) =>
      _journeys.doc(id);

  Future<JourneyEntity?> getJourney(String id) async {
    try {
      final doc = await _journeyDoc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return FirestoreMapper.journeyFromMap(doc.data()!);
    } on FirebaseException {
      return null;
    }
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

  Stream<List<JourneyEntity>> watchCreatedJourneys(String deviceId) {
    return _watchJourneysFromDeviceIndex(deviceId, role: 'host');
  }

  Stream<List<JourneyEntity>> watchJoinedJourneys(String deviceId) {
    return _watchJourneysFromDeviceIndex(deviceId, role: 'member');
  }

  Stream<List<JourneyEntity>> _watchJourneysFromDeviceIndex(
    String deviceId, {
    required String role,
  }) {
    return _deviceJourneyDs
        .watchJourneyIds(deviceId: deviceId, role: role)
        .asyncMap((journeyIds) async {
      if (journeyIds.isEmpty) return <JourneyEntity>[];

      final journeys = <JourneyEntity>[];
      for (final id in journeyIds) {
        final journey = await getJourney(id);
        if (journey != null) {
          journeys.add(journey);
        }
      }

      journeys.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return journeys;
    }).handleError((_, __) => <JourneyEntity>[]);
  }

  Future<void> pruneStaleDeviceJourneyRefs(String deviceId) async {
    await _deviceJourneyDs.pruneStaleRefs(
      deviceId: deviceId,
      isJourneyAccessible: (journeyId) async {
        final journey = await getJourney(journeyId);
        return journey != null;
      },
    );
  }

  Future<void> ensureDeviceJourneyRef({
    required String deviceId,
    required String journeyId,
    required String role,
  }) =>
      _deviceJourneyDs.upsertRef(
        deviceId: deviceId,
        journeyId: journeyId,
        role: role,
      );

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
    await _joinCodeDs.saveJoinCode(
      passCode: journey.passCode,
      journeyId: journey.id,
    );
  }

  Future<void> deleteJourney(String id, {String? hostDeviceId}) async {
    final journey = await getJourney(id);
    if (journey != null) {
      await _joinCodeDs.deactivateJoinCode(journey.passCode);
      await _deviceJourneyDs.removeRef(
        deviceId: journey.hostId,
        journeyId: id,
      );
    } else if (hostDeviceId != null) {
      await _deviceJourneyDs.removeRef(
        deviceId: hostDeviceId,
        journeyId: id,
      );
    }
    await _journeyDoc(id).delete();
  }

  Future<String?> resolveJourneyIdFromPasscode(String passCode) =>
      _joinCodeDs.resolveJourneyId(passCode);

  Future<JourneyEntity?> findByPasscode(String passCode) async {
    final journeyId = await _joinCodeDs.resolveJourneyId(passCode);
    if (journeyId == null) return null;
    return getJourney(journeyId);
  }
}
