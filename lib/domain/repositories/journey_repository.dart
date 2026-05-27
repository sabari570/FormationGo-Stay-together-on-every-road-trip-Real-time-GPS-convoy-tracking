import '../entities/journey.dart';
import '../entities/checkpoint.dart';

abstract class JourneyRepository {
  Future<JourneyEntity?> getJourney(String id);
  Future<List<JourneyEntity>> getAllJourneys();
  Stream<List<JourneyEntity>> watchJourneys();
  Future<void> saveJourney(JourneyEntity journey);
  Future<void> deleteJourney(String id);

  Future<List<CheckpointEntity>> getCheckpoints(String journeyId);
  Stream<List<CheckpointEntity>> watchCheckpoints(String journeyId);
  Future<void> saveCheckpoint(CheckpointEntity checkpoint);
  Future<void> deleteCheckpoint(String id);
}
