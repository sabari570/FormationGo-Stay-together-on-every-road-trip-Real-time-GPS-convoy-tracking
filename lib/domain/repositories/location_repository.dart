import '../entities/member_location.dart';

abstract class LocationRepository {
  Future<void> publishLocation(MemberLocationEntity location);
  Stream<List<MemberLocationEntity>> watchMemberLocations(String journeyId);
}
