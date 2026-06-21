import '../entities/journey_member.dart';

abstract class MemberRepository {
  Future<void> addMember(JourneyMemberEntity member);
  Future<JourneyMemberEntity?> getMember(String journeyId, String deviceId);
  Future<List<JourneyMemberEntity>> getMembers(String journeyId);
  Stream<List<JourneyMemberEntity>> watchMembers(String journeyId);
}
