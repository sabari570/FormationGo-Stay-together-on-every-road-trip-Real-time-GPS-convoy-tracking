import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/device_profile.dart';
import '../../../domain/entities/journey.dart';

part 'home_provider.g.dart';

@riverpod
Future<DeviceProfileEntity?> currentProfile(CurrentProfileRef ref) async {
  final deviceId = ref.watch(deviceIdProvider);
  final repo = ref.watch(deviceProfileRepositoryProvider);
  return repo.getProfile(deviceId);
}

@riverpod
Stream<List<JourneyEntity>> recentJourneys(RecentJourneysRef ref) {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.watchJourneys();
}
