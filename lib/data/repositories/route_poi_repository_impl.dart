import '../../domain/entities/route_poi.dart';
import '../../domain/repositories/route_poi_repository.dart';
import '../datasources/firestore/firestore_route_poi_datasource.dart';

class RoutePoiRepositoryImpl implements RoutePoiRepository {
  final FirestoreRoutePoiDatasource _datasource;

  RoutePoiRepositoryImpl(this._datasource);

  @override
  Future<List<RoutePoiEntity>> getPois(String journeyId) =>
      _datasource.getPois(journeyId);

  @override
  Stream<List<RoutePoiEntity>> watchPois(String journeyId) =>
      _datasource.watchPois(journeyId);

  @override
  Future<bool> hasPois(String journeyId) => _datasource.hasPois(journeyId);

  @override
  Future<void> savePois(List<RoutePoiEntity> pois) =>
      _datasource.savePois(pois);
}
