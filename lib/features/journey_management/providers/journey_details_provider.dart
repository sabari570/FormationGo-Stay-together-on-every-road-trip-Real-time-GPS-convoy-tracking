import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/firebase_auth_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey.dart';
import '../../../domain/entities/checkpoint.dart';

part 'journey_details_provider.g.dart';

@riverpod
Future<void> ensureDeviceJourneyIndex(
  EnsureDeviceJourneyIndexRef ref,
  String journeyId,
) async {
  await ref.watch(firebaseAuthReadyProvider.future);
  final deviceId = ref.read(deviceIdProvider);
  final member =
      await ref.read(memberRepositoryProvider).getMember(journeyId, deviceId);
  if (member == null) return;

  final role = member.role == 'host' ? 'host' : 'member';
  await ref.read(journeyRepositoryProvider).ensureDeviceJourneyRef(
        deviceId: deviceId,
        journeyId: journeyId,
        role: role,
      );
}

@riverpod
Stream<JourneyEntity?> watchJourneyDetails(
    WatchJourneyDetailsRef ref, String id) {
  return ref.watch(journeyRepositoryProvider).watchJourney(id);
}

@riverpod
Stream<List<CheckpointEntity>> watchCheckpoints(
    WatchCheckpointsRef ref, String journeyId) {
  return ref.watch(journeyRepositoryProvider).watchCheckpoints(journeyId);
}
