import '../../domain/entities/member_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/firestore/firestore_location_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final FirestoreLocationDatasource _datasource;

  LocationRepositoryImpl(this._datasource);

  @override
  Future<void> publishLocation(MemberLocationEntity location) =>
      _datasource.publishLocation(location);

  @override
  Stream<List<MemberLocationEntity>> watchMemberLocations(String journeyId) =>
      _datasource.watchLocations(journeyId);
}
