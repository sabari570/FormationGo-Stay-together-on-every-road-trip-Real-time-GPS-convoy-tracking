import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/relative_time.dart';
import '../../../domain/entities/journey_member.dart';
import '../../../domain/entities/member_location.dart';

const double proximityRadiusMeters = 500.0;

const Duration locationStaleAfter = Duration(minutes: 2);

enum ProximityStatus { inRange, approaching, outOfRange, unknown }

class MemberProximityInfo {
  final JourneyMemberEntity member;
  final MemberLocationEntity? location;
  final double? distanceMeters;
  final ProximityStatus status;

  const MemberProximityInfo({
    required this.member,
    required this.location,
    required this.distanceMeters,
    required this.status,
  });
}

double distanceMeters(
  double lat1,
  double lng1,
  double lat2,
  double lng2,
) =>
    Geolocator.distanceBetween(lat1, lng1, lat2, lng2);

bool isLocationFresh(MemberLocationEntity? location, {DateTime? now}) {
  if (location == null) return false;
  final reference = now ?? DateTime.now();
  return reference.difference(location.timestamp) <= locationStaleAfter;
}

ProximityStatus statusForDistance(double meters) {
  const greenThreshold = proximityRadiusMeters * 0.6;
  if (meters <= greenThreshold) return ProximityStatus.inRange;
  if (meters <= proximityRadiusMeters) return ProximityStatus.approaching;
  return ProximityStatus.outOfRange;
}

Color colorForStatus(ProximityStatus status) {
  switch (status) {
    case ProximityStatus.inRange:
      return AppColors.convoyGreen;
    case ProximityStatus.approaching:
      return AppColors.convoyAmber;
    case ProximityStatus.outOfRange:
      return AppColors.convoyRed;
    case ProximityStatus.unknown:
      return Colors.grey;
  }
}

String formatDistanceLabel(double meters) {
  if (meters >= 1000) {
    return '${(meters / 1000).toStringAsFixed(1)}km away';
  }
  return '${meters.round()}m away';
}

String locationStatusLabel(MemberLocationEntity? location) {
  if (location == null) return 'Waiting for GPS...';
  final age = DateTime.now().difference(location.timestamp);
  if (age > locationStaleAfter) {
    return 'Last seen ${formatTimeAgo(age)}';
  }
  if (location.speed > 1) {
    return 'Moving • ${(location.speed * 3.6).toStringAsFixed(0)} km/h';
  }
  return 'Active - Tracking GPS';
}

String memberProximitySubtitle({
  required bool isCurrentUser,
  required MemberLocationEntity? location,
  required double? distanceMeters,
}) {
  if (isCurrentUser) return 'Your location';

  if (!isLocationFresh(location)) {
    return locationStatusLabel(location);
  }

  if (distanceMeters == null) {
    return locationStatusLabel(location);
  }

  final distanceLabel = formatDistanceLabel(distanceMeters);
  if (location != null && location.speed > 1) {
    final speedLabel = '${(location.speed * 3.6).toStringAsFixed(0)} km/h';
    return '$distanceLabel • Moving • $speedLabel';
  }
  return distanceLabel;
}

Color locationStatusColor(MemberLocationEntity? location) {
  if (location == null) return Colors.grey;
  final age = DateTime.now().difference(location.timestamp);
  if (age > locationStaleAfter) return AppColors.convoyAmber;
  return AppColors.convoyGreen;
}

MemberProximityInfo? computeMemberProximity({
  required JourneyMemberEntity member,
  required MemberLocationEntity? location,
  required double viewerLat,
  required double viewerLng,
}) {
  if (!isLocationFresh(location)) {
    return MemberProximityInfo(
      member: member,
      location: location,
      distanceMeters: null,
      status: ProximityStatus.unknown,
    );
  }

  final meters = distanceMeters(
    viewerLat,
    viewerLng,
    location!.latitude,
    location.longitude,
  );

  return MemberProximityInfo(
    member: member,
    location: location,
    distanceMeters: meters,
    status: statusForDistance(meters),
  );
}
