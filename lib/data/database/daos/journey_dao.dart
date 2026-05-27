import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'journey_dao.g.dart';

@DriftAccessor(tables: [Journeys])
class JourneyDao extends DatabaseAccessor<AppDatabase> with _$JourneyDaoMixin {
  JourneyDao(AppDatabase db) : super(db);

  Future<Journey?> getJourney(String id) =>
      (select(journeys)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Journey>> getAllJourneys() => select(journeys).get();

  Stream<List<Journey>> watchJourneys() => select(journeys).watch();

  Future<void> saveJourney(JourneysCompanion journey) =>
      into(journeys).insertOnConflictUpdate(journey);

  Future<void> deleteJourney(String id) =>
      (delete(journeys)..where((t) => t.id.equals(id))).go();

  Future<List<Checkpoint>> getCheckpoints(String journeyId) =>
      (db.select(db.checkpoints)..where((t) => t.journeyId.equals(journeyId))).get();

  Stream<List<Checkpoint>> watchCheckpoints(String journeyId) =>
      (db.select(db.checkpoints)..where((t) => t.journeyId.equals(journeyId))).watch();

  Future<void> saveCheckpoint(CheckpointsCompanion checkpoint) =>
      db.into(db.checkpoints).insertOnConflictUpdate(checkpoint);

  Future<void> deleteCheckpoint(String id) =>
      (db.delete(db.checkpoints)..where((t) => t.id.equals(id))).go();
}
