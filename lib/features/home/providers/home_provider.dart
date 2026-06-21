import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/firebase_auth_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/device_profile.dart';
import '../../../domain/entities/journey.dart';
import '../../tracking/providers/live_location_provider.dart';

part 'home_provider.g.dart';

@riverpod
Future<DeviceProfileEntity?> currentProfile(CurrentProfileRef ref) async {
  final deviceId = ref.watch(deviceIdProvider);
  final repo = ref.watch(deviceProfileRepositoryProvider);
  return repo.getProfile(deviceId);
}

@Riverpod(keepAlive: true)
Future<void> homeJourneyIndexReady(HomeJourneyIndexReadyRef ref) async {
  await ref.watch(firebaseAuthReadyProvider.future);
  final deviceId = ref.read(deviceIdProvider);
  try {
    await ref
        .read(journeyRepositoryProvider)
        .pruneStaleDeviceJourneyRefs(deviceId);
  } on Object {
    // Ignore cleanup failures on a fresh or partially deleted database.
  }
}

Stream<List<JourneyEntity>> _deviceJourneyStream(
  Ref ref,
  Stream<List<JourneyEntity>> Function(String deviceId) watch,
) {
  ref.watch(homeJourneyIndexReadyProvider);
  final auth = ref.watch(firebaseAuthReadyProvider);
  if (!auth.hasValue || auth.valueOrNull == null) {
    return const Stream.empty();
  }

  final deviceId = ref.watch(deviceIdProvider);
  return watch(deviceId);
}

@riverpod
Stream<List<JourneyEntity>> createdJourneys(CreatedJourneysRef ref) {
  final repo = ref.watch(journeyRepositoryProvider);
  return _deviceJourneyStream(ref, repo.watchCreatedJourneys);
}

@riverpod
Stream<List<JourneyEntity>> joinedJourneys(JoinedJourneysRef ref) {
  final repo = ref.watch(journeyRepositoryProvider);
  return _deviceJourneyStream(ref, repo.watchJoinedJourneys);
}

@riverpod
bool isJourneyMember(IsJourneyMemberRef ref, String journeyId) {
  final deviceId = ref.watch(deviceIdProvider);
  final members =
      ref.watch(journeyMembersProvider(journeyId)).valueOrNull ?? [];
  return members.any((m) => m.deviceId == deviceId);
}
