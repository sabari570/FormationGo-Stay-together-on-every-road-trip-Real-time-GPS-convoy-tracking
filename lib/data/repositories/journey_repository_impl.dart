import 'package:drift/drift.dart';
import '../../domain/entities/journey.dart';
import '../../domain/entities/checkpoint.dart';
import '../../domain/repositories/journey_repository.dart';
import '../database/daos/journey_dao.dart';
import '../database/app_database.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  final JourneyDao _dao;

  JourneyRepositoryImpl(this._dao);

  JourneyEntity _mapToEntity(Journey journey) {
    return JourneyEntity(
      id: journey.id,
      name: journey.name,
      hostId: journey.hostId,
      passCode: journey.passCode,
      status: JourneyStatus.values.firstWhere(
        (e) => e.name == journey.status,
        orElse: () => JourneyStatus.active,
      ),
      createdAt: journey.createdAt,
      updatedAt: journey.updatedAt,
      sourceName: journey.sourceName,
      sourceLat: journey.sourceLat,
      sourceLng: journey.sourceLng,
      destinationName: journey.destinationName,
      destinationLat: journey.destinationLat,
      destinationLng: journey.destinationLng,
    );
  }

  @override
  Future<JourneyEntity?> getJourney(String id) async {
    final journey = await _dao.getJourney(id);
    if (journey == null) return null;
    return _mapToEntity(journey);
  }

  @override
  Future<List<JourneyEntity>> getAllJourneys() async {
    final journeys = await _dao.getAllJourneys();
    return journeys.map(_mapToEntity).toList();
  }

  @override
  Stream<List<JourneyEntity>> watchJourneys() {
    return _dao.watchJourneys().map((list) => list.map(_mapToEntity).toList());
  }

  @override
  Future<void> saveJourney(JourneyEntity journey) async {
    await _dao.saveJourney(
      JourneysCompanion(
        id: Value(journey.id),
        name: Value(journey.name),
        hostId: Value(journey.hostId),
        passCode: Value(journey.passCode),
        status: Value(journey.status.name),
        createdAt: Value(journey.createdAt),
        updatedAt: Value(journey.updatedAt),
        sourceName: Value(journey.sourceName),
        sourceLat: Value(journey.sourceLat),
        sourceLng: Value(journey.sourceLng),
        destinationName: Value(journey.destinationName),
        destinationLat: Value(journey.destinationLat),
        destinationLng: Value(journey.destinationLng),
      ),
    );
  }

  @override
  Future<void> deleteJourney(String id) async {
    await _dao.deleteJourney(id);
  }

  CheckpointEntity _mapCheckpointToEntity(Checkpoint cp) {
    return CheckpointEntity(
      id: cp.id,
      journeyId: cp.journeyId,
      name: cp.name,
      latitude: cp.latitude,
      longitude: cp.longitude,
      radius: cp.radius,
      type: cp.type,
    );
  }

  CheckpointsCompanion _mapCheckpointToCompanion(CheckpointEntity cp) {
    return CheckpointsCompanion(
      id: Value(cp.id),
      journeyId: Value(cp.journeyId),
      name: Value(cp.name),
      latitude: Value(cp.latitude),
      longitude: Value(cp.longitude),
      radius: Value(cp.radius),
      type: Value(cp.type),
    );
  }

  @override
  Future<List<CheckpointEntity>> getCheckpoints(String journeyId) async {
    final list = await _dao.getCheckpoints(journeyId);
    return list.map(_mapCheckpointToEntity).toList();
  }

  @override
  Stream<List<CheckpointEntity>> watchCheckpoints(String journeyId) {
    return _dao.watchCheckpoints(journeyId).map(
          (list) => list.map(_mapCheckpointToEntity).toList(),
        );
  }

  @override
  Future<void> saveCheckpoint(CheckpointEntity checkpoint) async {
    await _dao.saveCheckpoint(_mapCheckpointToCompanion(checkpoint));
  }

  @override
  Future<void> deleteCheckpoint(String id) async {
    await _dao.deleteCheckpoint(id);
  }
}
