import '../entities/journey.dart';

abstract class JourneyRepository {
  Future<JourneyEntity?> getJourney(String id);
  Future<List<JourneyEntity>> getAllJourneys();
  Stream<List<JourneyEntity>> watchJourneys();
  Future<void> saveJourney(JourneyEntity journey);
}
