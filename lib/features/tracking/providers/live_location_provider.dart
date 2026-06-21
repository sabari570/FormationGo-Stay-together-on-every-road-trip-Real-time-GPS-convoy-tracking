import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/device_identity_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/journey_member.dart';
import '../../../domain/entities/member_location.dart';
import 'location_provider.dart';

part 'live_location_provider.g.dart';

@riverpod
Stream<List<JourneyMemberEntity>> journeyMembers(
    JourneyMembersRef ref, String journeyId) {
  return ref.watch(memberRepositoryProvider).watchMembers(journeyId);
}

@riverpod
Stream<List<MemberLocationEntity>> memberLocations(
    MemberLocationsRef ref, String journeyId) {
  return ref.watch(locationRepositoryProvider).watchMemberLocations(journeyId);
}

@riverpod
class LiveLocationSync extends _$LiveLocationSync {
  DateTime? _lastPublish;

  @override
  void build(String journeyId) {
    ref.listen(locationStreamProvider, (_, next) {
      next.whenData((position) => _publishIfNeeded(journeyId, position));
    });
  }

  Future<void> _publishIfNeeded(String journeyId, Position position) async {
    final now = DateTime.now();
    if (_lastPublish != null &&
        now.difference(_lastPublish!) < const Duration(seconds: 8)) {
      return;
    }
    _lastPublish = now;

    final deviceId = ref.read(deviceIdProvider);
    await ref.read(locationRepositoryProvider).publishLocation(
          MemberLocationEntity(
            deviceId: deviceId,
            journeyId: journeyId,
            latitude: position.latitude,
            longitude: position.longitude,
            speed: position.speed,
            heading: position.heading,
            accuracy: position.accuracy,
            timestamp: now,
          ),
        );
  }
}
