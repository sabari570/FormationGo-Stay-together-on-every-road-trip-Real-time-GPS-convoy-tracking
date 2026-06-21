import '../../domain/entities/journey_member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/firestore/firestore_member_datasource.dart';

class MemberRepositoryImpl implements MemberRepository {
  final FirestoreMemberDatasource _datasource;

  MemberRepositoryImpl(this._datasource);

  @override
  Future<void> addMember(JourneyMemberEntity member) =>
      _datasource.addMember(member);

  @override
  Future<JourneyMemberEntity?> getMember(String journeyId, String deviceId) =>
      _datasource.getMember(journeyId, deviceId);

  @override
  Future<List<JourneyMemberEntity>> getMembers(String journeyId) =>
      _datasource.getMembers(journeyId);

  @override
  Stream<List<JourneyMemberEntity>> watchMembers(String journeyId) =>
      _datasource.watchMembers(journeyId);
}
