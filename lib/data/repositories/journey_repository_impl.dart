import '../../domain/entities/journey.dart';
import '../../domain/entities/checkpoint.dart';
import '../../domain/repositories/journey_repository.dart';
import '../datasources/firestore/firestore_journey_datasource.dart';
import '../datasources/firestore/firestore_checkpoint_datasource.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  final FirestoreJourneyDatasource _journeyDs;
  final FirestoreCheckpointDatasource _checkpointDs;

  JourneyRepositoryImpl(this._journeyDs, this._checkpointDs);

  @override
  Future<JourneyEntity?> getJourney(String id) => _journeyDs.getJourney(id);

  @override
  Future<List<JourneyEntity>> getAllJourneys() => _journeyDs.getAllJourneys();

  @override
  Stream<List<JourneyEntity>> watchJourneys() => _journeyDs.watchJourneys();

  @override
  Stream<List<JourneyEntity>> watchCreatedJourneys(String deviceId) =>
      _journeyDs.watchCreatedJourneys(deviceId);

  @override
  Stream<List<JourneyEntity>> watchJoinedJourneys(String deviceId) =>
      _journeyDs.watchJoinedJourneys(deviceId);

  @override
  Stream<JourneyEntity?> watchJourney(String id) => _journeyDs.watchJourney(id);

  @override
  Future<void> saveJourney(JourneyEntity journey) =>
      _journeyDs.saveJourney(journey);

  @override
  Future<void> ensureDeviceJourneyRef({
    required String deviceId,
    required String journeyId,
    required String role,
  }) =>
      _journeyDs.ensureDeviceJourneyRef(
        deviceId: deviceId,
        journeyId: journeyId,
        role: role,
      );

  @override
  Future<void> pruneStaleDeviceJourneyRefs(String deviceId) =>
      _journeyDs.pruneStaleDeviceJourneyRefs(deviceId);

  @override
  Future<void> deleteJourney(String id, {String? hostDeviceId}) =>
      _journeyDs.deleteJourney(id, hostDeviceId: hostDeviceId);

  @override
  Future<String?> resolveJourneyIdFromPasscode(String passCode) =>
      _journeyDs.resolveJourneyIdFromPasscode(passCode);

  @override
  Future<JourneyEntity?> findByPasscode(String passCode) =>
      _journeyDs.findByPasscode(passCode);

  @override
  Future<List<CheckpointEntity>> getCheckpoints(String journeyId) =>
      _checkpointDs.getCheckpoints(journeyId);

  @override
  Stream<List<CheckpointEntity>> watchCheckpoints(String journeyId) =>
      _checkpointDs.watchCheckpoints(journeyId);

  @override
  Future<void> saveCheckpoint(CheckpointEntity checkpoint) =>
      _checkpointDs.saveCheckpoint(checkpoint);

  @override
  Future<void> deleteCheckpoint(String journeyId, String id) =>
      _checkpointDs.deleteCheckpoint(journeyId, id);
}
