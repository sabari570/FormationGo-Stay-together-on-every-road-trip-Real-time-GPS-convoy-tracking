// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentProfileHash() => r'060a1fcb37b2d09a27369c84b0d8f0d74281e0e0';

/// See also [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider =
    AutoDisposeFutureProvider<DeviceProfileEntity?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentProfileRef = AutoDisposeFutureProviderRef<DeviceProfileEntity?>;
String _$recentJourneysHash() => r'a69120a9a6fe35cee23360a9567c3d99b9daf446';

/// See also [recentJourneys].
@ProviderFor(recentJourneys)
final recentJourneysProvider =
    AutoDisposeStreamProvider<List<JourneyEntity>>.internal(
  recentJourneys,
  name: r'recentJourneysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentJourneysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RecentJourneysRef = AutoDisposeStreamProviderRef<List<JourneyEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
