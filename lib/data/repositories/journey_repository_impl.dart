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
  Stream<JourneyEntity?> watchJourney(String id) => _journeyDs.watchJourney(id);

  @override
  Future<void> saveJourney(JourneyEntity journey) =>
      _journeyDs.saveJourney(journey);

  @override
  Future<void> deleteJourney(String id) => _journeyDs.deleteJourney(id);

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
