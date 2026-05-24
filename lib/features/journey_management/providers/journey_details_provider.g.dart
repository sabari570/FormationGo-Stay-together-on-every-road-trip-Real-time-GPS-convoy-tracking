// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchJourneyDetailsHash() =>
    r'34c9492e07e8b079e7548e988d3d8b760d45275a';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
