// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_proximity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memberProximityHash() => r'04ba7a70734b19cd8e04d579c2d503f9deb749ca';

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

/// See also [memberProximity].
@ProviderFor(memberProximity)
const memberProximityProvider = MemberProximityFamily();

/// See also [memberProximity].
class MemberProximityFamily extends Family<List<MemberProximityInfo>> {
  /// See also [memberProximity].
  const MemberProximityFamily();

  /// See also [memberProximity].
  MemberProximityProvider call(
    String journeyId,
  ) {
    return MemberProximityProvider(
      journeyId,
    );
  }

  @override
  MemberProximityProvider getProviderOverride(
    covariant MemberProximityProvider provider,
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
  String? get name => r'memberProximityProvider';
}

/// See also [memberProximity].
class MemberProximityProvider
    extends AutoDisposeProvider<List<MemberProximityInfo>> {
  /// See also [memberProximity].
  MemberProximityProvider(
    String journeyId,
  ) : this._internal(
          (ref) => memberProximity(
            ref as MemberProximityRef,
            journeyId,
          ),
          from: memberProximityProvider,
          name: r'memberProximityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$memberProximityHash,
          dependencies: MemberProximityFamily._dependencies,
          allTransitiveDependencies:
              MemberProximityFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  MemberProximityProvider._internal(
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
    List<MemberProximityInfo> Function(MemberProximityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberProximityProvider._internal(
        (ref) => create(ref as MemberProximityRef),
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
  AutoDisposeProviderElement<List<MemberProximityInfo>> createElement() {
    return _MemberProximityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberProximityProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MemberProximityRef on AutoDisposeProviderRef<List<MemberProximityInfo>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _MemberProximityProviderElement
    extends AutoDisposeProviderElement<List<MemberProximityInfo>>
    with MemberProximityRef {
  _MemberProximityProviderElement(super.provider);

  @override
  String get journeyId => (origin as MemberProximityProvider).journeyId;
}

String _$outOfRangeMemberCountHash() =>
    r'9fd964b6656dd7e2c6edce3b18e587fd3e9227ff';

/// See also [outOfRangeMemberCount].
@ProviderFor(outOfRangeMemberCount)
const outOfRangeMemberCountProvider = OutOfRangeMemberCountFamily();

/// See also [outOfRangeMemberCount].
class OutOfRangeMemberCountFamily extends Family<int> {
  /// See also [outOfRangeMemberCount].
  const OutOfRangeMemberCountFamily();

  /// See also [outOfRangeMemberCount].
  OutOfRangeMemberCountProvider call(
    String journeyId,
  ) {
    return OutOfRangeMemberCountProvider(
      journeyId,
    );
  }

  @override
  OutOfRangeMemberCountProvider getProviderOverride(
    covariant OutOfRangeMemberCountProvider provider,
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
  String? get name => r'outOfRangeMemberCountProvider';
}

/// See also [outOfRangeMemberCount].
class OutOfRangeMemberCountProvider extends AutoDisposeProvider<int> {
  /// See also [outOfRangeMemberCount].
  OutOfRangeMemberCountProvider(
    String journeyId,
  ) : this._internal(
          (ref) => outOfRangeMemberCount(
            ref as OutOfRangeMemberCountRef,
            journeyId,
          ),
          from: outOfRangeMemberCountProvider,
          name: r'outOfRangeMemberCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$outOfRangeMemberCountHash,
          dependencies: OutOfRangeMemberCountFamily._dependencies,
          allTransitiveDependencies:
              OutOfRangeMemberCountFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  OutOfRangeMemberCountProvider._internal(
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
    int Function(OutOfRangeMemberCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OutOfRangeMemberCountProvider._internal(
        (ref) => create(ref as OutOfRangeMemberCountRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _OutOfRangeMemberCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutOfRangeMemberCountProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OutOfRangeMemberCountRef on AutoDisposeProviderRef<int> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _OutOfRangeMemberCountProviderElement
    extends AutoDisposeProviderElement<int> with OutOfRangeMemberCountRef {
  _OutOfRangeMemberCountProviderElement(super.provider);

  @override
  String get journeyId => (origin as OutOfRangeMemberCountProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
