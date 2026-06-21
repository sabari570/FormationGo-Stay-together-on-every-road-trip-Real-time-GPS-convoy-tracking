import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/journey_member.dart';
import '../../home/providers/home_provider.dart';

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

      final journeyId = await journeyRepo.resolveJourneyIdFromPasscode(pin);
      if (journeyId == null) {
        state = AsyncValue.error(
          Exception('No active journey found with passcode $pin'),
          StackTrace.current,
        );
        return null;
      }

      final existingMember =
          await memberRepo.getMember(journeyId, deviceId);

      if (existingMember == null) {
        await memberRepo.addMember(
          JourneyMemberEntity(
            id: deviceId,
            journeyId: journeyId,
            deviceId: deviceId,
            role: 'member',
            name: profile?.name ?? 'Member',
            avatarColor: profile?.avatarColor ?? '#2196F3',
            joinTime: DateTime.now(),
          ),
        );
      }

      final authUid = FirebaseAuth.instance.currentUser?.uid;
      if (authUid != null) {
        await ref.read(memberAuthDatasourceProvider).upsertMemberAuth(
              journeyId: journeyId,
              authUid: authUid,
              deviceId: deviceId,
              name: profile?.name ?? 'Member',
              avatarColor: profile?.avatarColor ?? '#2196F3',
            );
      }

      await journeyRepo.ensureDeviceJourneyRef(
        deviceId: deviceId,
        journeyId: journeyId,
        role: existingMember?.role == 'host' ? 'host' : 'member',
      );

      ref.invalidate(homeJourneyIndexReadyProvider);

      final journey = await journeyRepo.getJourney(journeyId);
      if (journey == null) {
        state = AsyncValue.error(
          Exception('Journey not found after joining'),
          StackTrace.current,
        );
        return null;
      }

      state = AsyncValue.data(journey);
      return journey;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    return null;
  }
}
