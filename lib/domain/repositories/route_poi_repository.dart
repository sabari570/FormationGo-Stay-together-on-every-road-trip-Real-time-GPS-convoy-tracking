import '../entities/route_poi.dart';

abstract class RoutePoiRepository {
  Future<List<RoutePoiEntity>> getPois(String journeyId);
  Stream<List<RoutePoiEntity>> watchPois(String journeyId);
  Future<bool> hasPois(String journeyId);
  Future<void> savePois(List<RoutePoiEntity> pois);
}
