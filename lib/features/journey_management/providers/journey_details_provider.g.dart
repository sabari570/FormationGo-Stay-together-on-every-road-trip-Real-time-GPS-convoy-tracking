// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ensureDeviceJourneyIndexHash() =>
    r'4acd704ad61838d2d473b1e23cc13562a43474b8';

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

/// See also [ensureDeviceJourneyIndex].
@ProviderFor(ensureDeviceJourneyIndex)
const ensureDeviceJourneyIndexProvider = EnsureDeviceJourneyIndexFamily();

/// See also [ensureDeviceJourneyIndex].
class EnsureDeviceJourneyIndexFamily extends Family<AsyncValue<void>> {
  /// See also [ensureDeviceJourneyIndex].
  const EnsureDeviceJourneyIndexFamily();

  /// See also [ensureDeviceJourneyIndex].
  EnsureDeviceJourneyIndexProvider call(
    String journeyId,
  ) {
    return EnsureDeviceJourneyIndexProvider(
      journeyId,
    );
  }

  @override
  EnsureDeviceJourneyIndexProvider getProviderOverride(
    covariant EnsureDeviceJourneyIndexProvider provider,
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
  String? get name => r'ensureDeviceJourneyIndexProvider';
}

/// See also [ensureDeviceJourneyIndex].
class EnsureDeviceJourneyIndexProvider extends AutoDisposeFutureProvider<void> {
  /// See also [ensureDeviceJourneyIndex].
  EnsureDeviceJourneyIndexProvider(
    String journeyId,
  ) : this._internal(
          (ref) => ensureDeviceJourneyIndex(
            ref as EnsureDeviceJourneyIndexRef,
            journeyId,
          ),
          from: ensureDeviceJourneyIndexProvider,
          name: r'ensureDeviceJourneyIndexProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ensureDeviceJourneyIndexHash,
          dependencies: EnsureDeviceJourneyIndexFamily._dependencies,
          allTransitiveDependencies:
              EnsureDeviceJourneyIndexFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  EnsureDeviceJourneyIndexProvider._internal(
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
    FutureOr<void> Function(EnsureDeviceJourneyIndexRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EnsureDeviceJourneyIndexProvider._internal(
        (ref) => create(ref as EnsureDeviceJourneyIndexRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _EnsureDeviceJourneyIndexProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnsureDeviceJourneyIndexProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EnsureDeviceJourneyIndexRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _EnsureDeviceJourneyIndexProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with EnsureDeviceJourneyIndexRef {
  _EnsureDeviceJourneyIndexProviderElement(super.provider);

  @override
  String get journeyId =>
      (origin as EnsureDeviceJourneyIndexProvider).journeyId;
}

String _$watchJourneyDetailsHash() =>
    r'efe0c73a4c2c94134de3497db026b1d65fd42951';

/// See also [watchJourneyDetails].
@ProviderFor(watchJourneyDetails)
const watchJourneyDetailsProvider = WatchJourneyDetailsFamily();

/// See also [watchJourneyDetails].
class WatchJourneyDetailsFamily extends Family<AsyncValue<JourneyEntity?>> {
  /// See also [watchJourneyDetails].
  const WatchJourneyDetailsFamily();

  /// See also [watchJourneyDetails].
  WatchJourneyDetailsProvider call(
    String id,
  ) {
    return WatchJourneyDetailsProvider(
      id,
    );
  }

  @override
  WatchJourneyDetailsProvider getProviderOverride(
    covariant WatchJourneyDetailsProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'watchJourneyDetailsProvider';
}

/// See also [watchJourneyDetails].
class WatchJourneyDetailsProvider
    extends AutoDisposeStreamProvider<JourneyEntity?> {
  /// See also [watchJourneyDetails].
  WatchJourneyDetailsProvider(
    String id,
  ) : this._internal(
          (ref) => watchJourneyDetails(
            ref as WatchJourneyDetailsRef,
            id,
          ),
          from: watchJourneyDetailsProvider,
          name: r'watchJourneyDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchJourneyDetailsHash,
          dependencies: WatchJourneyDetailsFamily._dependencies,
          allTransitiveDependencies:
              WatchJourneyDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  WatchJourneyDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<JourneyEntity?> Function(WatchJourneyDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchJourneyDetailsProvider._internal(
        (ref) => create(ref as WatchJourneyDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<JourneyEntity?> createElement() {
    return _WatchJourneyDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchJourneyDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchJourneyDetailsRef on AutoDisposeStreamProviderRef<JourneyEntity?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _WatchJourneyDetailsProviderElement
    extends AutoDisposeStreamProviderElement<JourneyEntity?>
    with WatchJourneyDetailsRef {
  _WatchJourneyDetailsProviderElement(super.provider);

  @override
  String get id => (origin as WatchJourneyDetailsProvider).id;
}

String _$watchCheckpointsHash() => r'bf83edb41f914cdf6dbaaf0a777a0d9fa27a5069';

/// See also [watchCheckpoints].
@ProviderFor(watchCheckpoints)
const watchCheckpointsProvider = WatchCheckpointsFamily();

/// See also [watchCheckpoints].
class WatchCheckpointsFamily
    extends Family<AsyncValue<List<CheckpointEntity>>> {
  /// See also [watchCheckpoints].
  const WatchCheckpointsFamily();

  /// See also [watchCheckpoints].
  WatchCheckpointsProvider call(
    String journeyId,
  ) {
    return WatchCheckpointsProvider(
      journeyId,
    );
  }

  @override
  WatchCheckpointsProvider getProviderOverride(
    covariant WatchCheckpointsProvider provider,
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
  String? get name => r'watchCheckpointsProvider';
}

/// See also [watchCheckpoints].
class WatchCheckpointsProvider
    extends AutoDisposeStreamProvider<List<CheckpointEntity>> {
  /// See also [watchCheckpoints].
  WatchCheckpointsProvider(
    String journeyId,
  ) : this._internal(
          (ref) => watchCheckpoints(
            ref as WatchCheckpointsRef,
            journeyId,
          ),
          from: watchCheckpointsProvider,
          name: r'watchCheckpointsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchCheckpointsHash,
          dependencies: WatchCheckpointsFamily._dependencies,
          allTransitiveDependencies:
              WatchCheckpointsFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  WatchCheckpointsProvider._internal(
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
    Stream<List<CheckpointEntity>> Function(WatchCheckpointsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchCheckpointsProvider._internal(
        (ref) => create(ref as WatchCheckpointsRef),
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
  AutoDisposeStreamProviderElement<List<CheckpointEntity>> createElement() {
    return _WatchCheckpointsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchCheckpointsProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchCheckpointsRef
    on AutoDisposeStreamProviderRef<List<CheckpointEntity>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _WatchCheckpointsProviderElement
    extends AutoDisposeStreamProviderElement<List<CheckpointEntity>>
    with WatchCheckpointsRef {
  _WatchCheckpointsProviderElement(super.provider);

  @override
  String get journeyId => (origin as WatchCheckpointsProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
