import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/group_message.dart';
import '../../../domain/entities/journey_member.dart';
import '../../home/providers/home_provider.dart';
import '../../journey_management/providers/journey_details_provider.dart';
import '../../tracking/providers/live_location_provider.dart';

part 'group_chat_provider.g.dart';

@riverpod
Future<void> ensureGroupChatMemberAuth(
  EnsureGroupChatMemberAuthRef ref,
  String journeyId,
) async {
  final authUid = FirebaseAuth.instance.currentUser?.uid;
  if (authUid == null) return;

  final deviceId = ref.read(deviceIdProvider);
  final members =
      ref.read(journeyMembersProvider(journeyId)).valueOrNull ?? [];
  JourneyMemberEntity? member;
  for (final item in members) {
    if (item.deviceId == deviceId) {
      member = item;
      break;
    }
  }
  if (member == null) return;

  final profile = ref.read(currentProfileProvider).valueOrNull;
  await ref.read(memberAuthDatasourceProvider).upsertMemberAuth(
        journeyId: journeyId,
        authUid: authUid,
        deviceId: deviceId,
        name: profile?.name ?? member.name,
        avatarColor: profile?.avatarColor ?? member.avatarColor,
      );
}

@riverpod
Stream<List<GroupMessageEntity>> groupChatMessages(
  GroupChatMessagesRef ref,
  String journeyId,
) {
  final journeyRepo = ref.watch(journeyRepositoryProvider);
  return journeyRepo.watchJourney(journeyId).asyncExpand((journey) {
    if (journey == null) {
      return Stream.value(const <GroupMessageEntity>[]);
    }
    return ref
        .watch(groupChatRepositoryProvider)
        .watchMessages(journeyId, journey.passCode);
  });
}

@riverpod
class GroupChatNotifier extends _$GroupChatNotifier {
  @override
  void build(String journeyId) {}

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final journey =
        ref.read(watchJourneyDetailsProvider(journeyId)).valueOrNull ??
            await ref.read(journeyRepositoryProvider).getJourney(journeyId);
    if (journey == null) return;

    final deviceId = ref.read(deviceIdProvider);
    final members =
        ref.read(journeyMembersProvider(journeyId)).valueOrNull ?? [];
    if (!members.any((member) => member.deviceId == deviceId)) return;

    final profile = ref.read(currentProfileProvider).valueOrNull;
    final member = members.firstWhere(
      (m) => m.deviceId == deviceId,
      orElse: () => members.first,
    );

    await ref.read(groupChatRepositoryProvider).sendMessage(
          journeyId: journeyId,
          passCode: journey.passCode,
          senderDeviceId: deviceId,
          senderName: profile?.name ?? member.name,
          senderAvatarColor: profile?.avatarColor ?? member.avatarColor,
          content: trimmed,
        );
  }
}

@riverpod
bool groupChatReady(GroupChatReadyRef ref, String journeyId) {
  final journey =
      ref.watch(watchJourneyDetailsProvider(journeyId)).valueOrNull;
  return journey != null;
}
