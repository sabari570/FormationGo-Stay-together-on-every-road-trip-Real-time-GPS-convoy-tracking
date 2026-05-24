import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/device_profile.dart';

part 'profile_creation_provider.g.dart';

@riverpod
class ProfileCreation extends _$ProfileCreation {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createProfile({required String name, required String avatarColor}) async {
    state = const AsyncValue.loading();
    try {
      final deviceId = ref.read(deviceIdProvider);
      final repo = ref.read(deviceProfileRepositoryProvider);
      
      final profile = DeviceProfileEntity(
        id: deviceId,
        name: name,
        avatarColor: avatarColor,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.saveProfile(profile);
      await ref.read(deviceIdentityServiceProvider).completeOnboarding();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
