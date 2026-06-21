import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/device_identity_provider.dart';
import '../utils/proximity_utils.dart';
import 'live_location_provider.dart';
import 'location_provider.dart';

part 'member_proximity_provider.g.dart';

@riverpod
List<MemberProximityInfo> memberProximity(
  MemberProximityRef ref,
  String journeyId,
) {
  final members = ref.watch(journeyMembersProvider(journeyId)).valueOrNull ?? [];
  final locations =
      ref.watch(memberLocationsProvider(journeyId)).valueOrNull ?? [];
  final viewerPosition = ref.watch(locationStreamProvider).valueOrNull;
  final currentDeviceId = ref.watch(deviceIdProvider);

  if (viewerPosition == null) return const [];

  final locationByDevice = {
    for (final loc in locations) loc.deviceId: loc,
  };

  final proximityList = <MemberProximityInfo>[];
  for (final member in members) {
    if (member.deviceId == currentDeviceId) continue;

    final info = computeMemberProximity(
      member: member,
      location: locationByDevice[member.deviceId],
      viewerLat: viewerPosition.latitude,
      viewerLng: viewerPosition.longitude,
    );
    if (info != null) {
      proximityList.add(info);
    }
  }

  proximityList.sort((a, b) {
    final aDistance = a.distanceMeters;
    final bDistance = b.distanceMeters;
    if (aDistance == null && bDistance == null) return 0;
    if (aDistance == null) return 1;
    if (bDistance == null) return -1;
    return aDistance.compareTo(bDistance);
  });

  return proximityList;
}

@riverpod
int outOfRangeMemberCount(OutOfRangeMemberCountRef ref, String journeyId) {
  final proximity = ref.watch(memberProximityProvider(journeyId));
  return proximity
      .where((info) => info.status == ProximityStatus.outOfRange)
      .length;
}
