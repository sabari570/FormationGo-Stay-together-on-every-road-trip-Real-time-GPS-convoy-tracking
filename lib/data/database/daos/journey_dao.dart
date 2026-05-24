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
}
