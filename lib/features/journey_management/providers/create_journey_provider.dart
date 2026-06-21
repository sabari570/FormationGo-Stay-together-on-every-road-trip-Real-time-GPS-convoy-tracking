import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/journey_member.dart';
import '../../../features/home/providers/home_provider.dart';

part 'create_journey_provider.g.dart';

@riverpod
class CreateJourney extends _$CreateJourney {
  @override
  AsyncValue<JourneyEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createJourney(String name) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(journeyRepositoryProvider);
      final memberRepo = ref.read(memberRepositoryProvider);
      final hostId = ref.read(deviceIdProvider);
      final profile = await ref.read(currentProfileProvider.future);

      final passcode = (100000 + Random().nextInt(900000)).toString();

      final journey = JourneyEntity(
        id: const Uuid().v4(),
        name: name,
        hostId: hostId,
        passCode: passcode,
        status: JourneyStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.saveJourney(journey);

      await memberRepo.addMember(
        JourneyMemberEntity(
          id: hostId,
          journeyId: journey.id,
          deviceId: hostId,
          role: 'host',
          name: profile?.name ?? 'Host',
          avatarColor: profile?.avatarColor ?? '#4CAF50',
          joinTime: DateTime.now(),
        ),
      );

      final authUid = FirebaseAuth.instance.currentUser?.uid;
      if (authUid != null) {
        await ref.read(memberAuthDatasourceProvider).upsertMemberAuth(
              journeyId: journey.id,
              authUid: authUid,
              deviceId: hostId,
              name: profile?.name ?? 'Host',
              avatarColor: profile?.avatarColor ?? '#4CAF50',
            );
      }

      state = AsyncValue.data(journey);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
