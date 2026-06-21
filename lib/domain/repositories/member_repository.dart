import '../entities/journey_member.dart';

abstract class MemberRepository {
  Future<void> addMember(JourneyMemberEntity member);
  Future<List<JourneyMemberEntity>> getMembers(String journeyId);
  Stream<List<JourneyMemberEntity>> watchMembers(String journeyId);
}
