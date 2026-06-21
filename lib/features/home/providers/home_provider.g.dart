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
String _$homeJourneyIndexReadyHash() =>
    r'96997ca873d3401619031a3bbf83648626e30fa8';

/// See also [homeJourneyIndexReady].
@ProviderFor(homeJourneyIndexReady)
final homeJourneyIndexReadyProvider = FutureProvider<void>.internal(
  homeJourneyIndexReady,
  name: r'homeJourneyIndexReadyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeJourneyIndexReadyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HomeJourneyIndexReadyRef = FutureProviderRef<void>;
String _$createdJourneysHash() => r'18b72663b105321b32b805b68837efeecb6a4de4';

/// See also [createdJourneys].
@ProviderFor(createdJourneys)
final createdJourneysProvider =
    AutoDisposeStreamProvider<List<JourneyEntity>>.internal(
  createdJourneys,
  name: r'createdJourneysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createdJourneysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreatedJourneysRef = AutoDisposeStreamProviderRef<List<JourneyEntity>>;
String _$joinedJourneysHash() => r'5538270a272f9e558382e70a9658abe36b57c858';

/// See also [joinedJourneys].
@ProviderFor(joinedJourneys)
final joinedJourneysProvider =
    AutoDisposeStreamProvider<List<JourneyEntity>>.internal(
  joinedJourneys,
  name: r'joinedJourneysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$joinedJourneysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JoinedJourneysRef = AutoDisposeStreamProviderRef<List<JourneyEntity>>;
String _$isJourneyMemberHash() => r'206a0c9a7af7a578b849664b735d493903de548d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [isJourneyMember].
@ProviderFor(isJourneyMember)
const isJourneyMemberProvider = IsJourneyMemberFamily();

/// See also [isJourneyMember].
class IsJourneyMemberFamily extends Family<bool> {
  /// See also [isJourneyMember].
  const IsJourneyMemberFamily();

  /// See also [isJourneyMember].
  IsJourneyMemberProvider call(
    String journeyId,
  ) {
    return IsJourneyMemberProvider(
      journeyId,
    );
  }

  @override
  IsJourneyMemberProvider getProviderOverride(
    covariant IsJourneyMemberProvider provider,
  ) {
    return call(
      provider.journeyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isJourneyMemberProvider';
}

/// See also [isJourneyMember].
class IsJourneyMemberProvider extends AutoDisposeProvider<bool> {
  /// See also [isJourneyMember].
  IsJourneyMemberProvider(
    String journeyId,
  ) : this._internal(
          (ref) => isJourneyMember(
            ref as IsJourneyMemberRef,
            journeyId,
          ),
          from: isJourneyMemberProvider,
          name: r'isJourneyMemberProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isJourneyMemberHash,
          dependencies: IsJourneyMemberFamily._dependencies,
          allTransitiveDependencies:
              IsJourneyMemberFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  IsJourneyMemberProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.journeyId,
  }) : super.internal();

  final String journeyId;

  @override
  Override overrideWith(
    bool Function(IsJourneyMemberRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsJourneyMemberProvider._internal(
        (ref) => create(ref as IsJourneyMemberRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        journeyId: journeyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsJourneyMemberProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsJourneyMemberProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsJourneyMemberRef on AutoDisposeProviderRef<bool> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _IsJourneyMemberProviderElement extends AutoDisposeProviderElement<bool>
    with IsJourneyMemberRef {
  _IsJourneyMemberProviderElement(super.provider);

  @override
  String get journeyId => (origin as IsJourneyMemberProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
