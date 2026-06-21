// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journeyMembersHash() => r'd84e0044ea1b4d006866772ee2e82147cf2362cb';

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

/// See also [journeyMembers].
@ProviderFor(journeyMembers)
const journeyMembersProvider = JourneyMembersFamily();

/// See also [journeyMembers].
class JourneyMembersFamily
    extends Family<AsyncValue<List<JourneyMemberEntity>>> {
  /// See also [journeyMembers].
  const JourneyMembersFamily();

  /// See also [journeyMembers].
  JourneyMembersProvider call(
    String journeyId,
  ) {
    return JourneyMembersProvider(
      journeyId,
    );
  }

  @override
  JourneyMembersProvider getProviderOverride(
    covariant JourneyMembersProvider provider,
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
  String? get name => r'journeyMembersProvider';
}

/// See also [journeyMembers].
class JourneyMembersProvider
    extends AutoDisposeStreamProvider<List<JourneyMemberEntity>> {
  /// See also [journeyMembers].
  JourneyMembersProvider(
    String journeyId,
  ) : this._internal(
          (ref) => journeyMembers(
            ref as JourneyMembersRef,
            journeyId,
          ),
          from: journeyMembersProvider,
          name: r'journeyMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journeyMembersHash,
          dependencies: JourneyMembersFamily._dependencies,
          allTransitiveDependencies:
              JourneyMembersFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  JourneyMembersProvider._internal(
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
    Stream<List<JourneyMemberEntity>> Function(JourneyMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JourneyMembersProvider._internal(
        (ref) => create(ref as JourneyMembersRef),
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
  AutoDisposeStreamProviderElement<List<JourneyMemberEntity>> createElement() {
    return _JourneyMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JourneyMembersProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JourneyMembersRef
    on AutoDisposeStreamProviderRef<List<JourneyMemberEntity>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _JourneyMembersProviderElement
    extends AutoDisposeStreamProviderElement<List<JourneyMemberEntity>>
    with JourneyMembersRef {
  _JourneyMembersProviderElement(super.provider);

  @override
  String get journeyId => (origin as JourneyMembersProvider).journeyId;
}

String _$memberLocationsHash() => r'a9de98a4323ef51cd8b576b4ed440b00719c2d25';

/// See also [memberLocations].
@ProviderFor(memberLocations)
const memberLocationsProvider = MemberLocationsFamily();

/// See also [memberLocations].
class MemberLocationsFamily
    extends Family<AsyncValue<List<MemberLocationEntity>>> {
  /// See also [memberLocations].
  const MemberLocationsFamily();

  /// See also [memberLocations].
  MemberLocationsProvider call(
    String journeyId,
  ) {
    return MemberLocationsProvider(
      journeyId,
    );
  }

  @override
  MemberLocationsProvider getProviderOverride(
    covariant MemberLocationsProvider provider,
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
  String? get name => r'memberLocationsProvider';
}

/// See also [memberLocations].
class MemberLocationsProvider
    extends AutoDisposeStreamProvider<List<MemberLocationEntity>> {
  /// See also [memberLocations].
  MemberLocationsProvider(
    String journeyId,
  ) : this._internal(
          (ref) => memberLocations(
            ref as MemberLocationsRef,
            journeyId,
          ),
          from: memberLocationsProvider,
          name: r'memberLocationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$memberLocationsHash,
          dependencies: MemberLocationsFamily._dependencies,
          allTransitiveDependencies:
              MemberLocationsFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  MemberLocationsProvider._internal(
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
    Stream<List<MemberLocationEntity>> Function(MemberLocationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberLocationsProvider._internal(
        (ref) => create(ref as MemberLocationsRef),
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
  AutoDisposeStreamProviderElement<List<MemberLocationEntity>> createElement() {
    return _MemberLocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberLocationsProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MemberLocationsRef
    on AutoDisposeStreamProviderRef<List<MemberLocationEntity>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _MemberLocationsProviderElement
    extends AutoDisposeStreamProviderElement<List<MemberLocationEntity>>
    with MemberLocationsRef {
  _MemberLocationsProviderElement(super.provider);

  @override
  String get journeyId => (origin as MemberLocationsProvider).journeyId;
}

String _$liveLocationSyncHash() => r'4929f1657141a26262b70d80a7f611a5138178ef';

abstract class _$LiveLocationSync extends BuildlessAutoDisposeNotifier<void> {
  late final String journeyId;

  void build(
    String journeyId,
  );
}

/// See also [LiveLocationSync].
@ProviderFor(LiveLocationSync)
const liveLocationSyncProvider = LiveLocationSyncFamily();

/// See also [LiveLocationSync].
class LiveLocationSyncFamily extends Family<void> {
  /// See also [LiveLocationSync].
  const LiveLocationSyncFamily();

  /// See also [LiveLocationSync].
  LiveLocationSyncProvider call(
    String journeyId,
  ) {
    return LiveLocationSyncProvider(
      journeyId,
    );
  }

  @override
  LiveLocationSyncProvider getProviderOverride(
    covariant LiveLocationSyncProvider provider,
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
  String? get name => r'liveLocationSyncProvider';
}

/// See also [LiveLocationSync].
class LiveLocationSyncProvider
    extends AutoDisposeNotifierProviderImpl<LiveLocationSync, void> {
  /// See also [LiveLocationSync].
  LiveLocationSyncProvider(
    String journeyId,
  ) : this._internal(
          () => LiveLocationSync()..journeyId = journeyId,
          from: liveLocationSyncProvider,
          name: r'liveLocationSyncProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$liveLocationSyncHash,
          dependencies: LiveLocationSyncFamily._dependencies,
          allTransitiveDependencies:
              LiveLocationSyncFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  LiveLocationSyncProvider._internal(
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
  void runNotifierBuild(
    covariant LiveLocationSync notifier,
  ) {
    return notifier.build(
      journeyId,
    );
  }

  @override
  Override overrideWith(LiveLocationSync Function() create) {
    return ProviderOverride(
      origin: this,
      override: LiveLocationSyncProvider._internal(
        () => create()..journeyId = journeyId,
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
  AutoDisposeNotifierProviderElement<LiveLocationSync, void> createElement() {
    return _LiveLocationSyncProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveLocationSyncProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LiveLocationSyncRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _LiveLocationSyncProviderElement
    extends AutoDisposeNotifierProviderElement<LiveLocationSync, void>
    with LiveLocationSyncRef {
  _LiveLocationSyncProviderElement(super.provider);

  @override
  String get journeyId => (origin as LiveLocationSyncProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
