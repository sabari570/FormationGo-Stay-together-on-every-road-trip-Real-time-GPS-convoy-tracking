import '../entities/journey.dart';
import '../entities/checkpoint.dart';

abstract class JourneyRepository {
  Future<JourneyEntity?> getJourney(String id);
  Future<List<JourneyEntity>> getAllJourneys();
  Stream<List<JourneyEntity>> watchJourneys();
  Stream<List<JourneyEntity>> watchCreatedJourneys(String deviceId);
  Stream<List<JourneyEntity>> watchJoinedJourneys(String deviceId);
  Stream<JourneyEntity?> watchJourney(String id);
  Future<void> saveJourney(JourneyEntity journey);
  Future<void> ensureDeviceJourneyRef({
    required String deviceId,
    required String journeyId,
    required String role,
  });
  Future<void> pruneStaleDeviceJourneyRefs(String deviceId);
  Future<void> deleteJourney(String id, {String? hostDeviceId});
  Future<String?> resolveJourneyIdFromPasscode(String passCode);
  Future<JourneyEntity?> findByPasscode(String passCode);

  Future<List<CheckpointEntity>> getCheckpoints(String journeyId);
  Stream<List<CheckpointEntity>> watchCheckpoints(String journeyId);
  Future<void> saveCheckpoint(CheckpointEntity checkpoint);
  Future<void> deleteCheckpoint(String journeyId, String id);
}
