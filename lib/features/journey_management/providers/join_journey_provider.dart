import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/journey_member.dart';
import '../../../features/home/providers/home_provider.dart';

part 'join_journey_provider.g.dart';

@riverpod
class JoinJourney extends _$JoinJourney {
  @override
  AsyncValue<JourneyEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<JourneyEntity?> joinJourney(String pin) async {
    state = const AsyncValue.loading();
    try {
      final journeyRepo = ref.read(journeyRepositoryProvider);
      final memberRepo = ref.read(memberRepositoryProvider);
      final deviceId = ref.read(deviceIdProvider);
      final profile = await ref.read(currentProfileProvider.future);

      final foundJourney = await journeyRepo.findByPasscode(pin);

      if (foundJourney != null) {
        final existingMembers = await memberRepo.getMembers(foundJourney.id);
        final alreadyJoined =
            existingMembers.any((m) => m.deviceId == deviceId);

        if (!alreadyJoined) {
          await memberRepo.addMember(
            JourneyMemberEntity(
              id: deviceId,
              journeyId: foundJourney.id,
              deviceId: deviceId,
              role: foundJourney.hostId == deviceId ? 'host' : 'member',
              name: profile?.name ?? 'Member',
              avatarColor: profile?.avatarColor ?? '#2196F3',
              joinTime: DateTime.now(),
            ),
          );
        }

        final authUid = FirebaseAuth.instance.currentUser?.uid;
        if (authUid != null) {
          await ref.read(memberAuthDatasourceProvider).upsertMemberAuth(
                journeyId: foundJourney.id,
                authUid: authUid,
                deviceId: deviceId,
                name: profile?.name ?? 'Member',
                avatarColor: profile?.avatarColor ?? '#2196F3',
              );
        }

        state = AsyncValue.data(foundJourney);
        return foundJourney;
      }

      state = AsyncValue.error(
        Exception('No active journey found with passcode $pin'),
        StackTrace.current,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    return null;
  }
}
