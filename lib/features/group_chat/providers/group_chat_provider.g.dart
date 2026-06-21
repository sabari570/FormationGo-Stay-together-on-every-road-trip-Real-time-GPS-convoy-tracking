// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ensureGroupChatMemberAuthHash() =>
    r'0bc857a44f6fb1d3ee00950bda28650e5bdafb66';

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

/// See also [ensureGroupChatMemberAuth].
@ProviderFor(ensureGroupChatMemberAuth)
const ensureGroupChatMemberAuthProvider = EnsureGroupChatMemberAuthFamily();

/// See also [ensureGroupChatMemberAuth].
class EnsureGroupChatMemberAuthFamily extends Family<AsyncValue<void>> {
  /// See also [ensureGroupChatMemberAuth].
  const EnsureGroupChatMemberAuthFamily();

  /// See also [ensureGroupChatMemberAuth].
  EnsureGroupChatMemberAuthProvider call(
    String journeyId,
  ) {
    return EnsureGroupChatMemberAuthProvider(
      journeyId,
    );
  }

  @override
  EnsureGroupChatMemberAuthProvider getProviderOverride(
    covariant EnsureGroupChatMemberAuthProvider provider,
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
  String? get name => r'ensureGroupChatMemberAuthProvider';
}

/// See also [ensureGroupChatMemberAuth].
class EnsureGroupChatMemberAuthProvider
    extends AutoDisposeFutureProvider<void> {
  /// See also [ensureGroupChatMemberAuth].
  EnsureGroupChatMemberAuthProvider(
    String journeyId,
  ) : this._internal(
          (ref) => ensureGroupChatMemberAuth(
            ref as EnsureGroupChatMemberAuthRef,
            journeyId,
          ),
          from: ensureGroupChatMemberAuthProvider,
          name: r'ensureGroupChatMemberAuthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ensureGroupChatMemberAuthHash,
          dependencies: EnsureGroupChatMemberAuthFamily._dependencies,
          allTransitiveDependencies:
              EnsureGroupChatMemberAuthFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  EnsureGroupChatMemberAuthProvider._internal(
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
    FutureOr<void> Function(EnsureGroupChatMemberAuthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EnsureGroupChatMemberAuthProvider._internal(
        (ref) => create(ref as EnsureGroupChatMemberAuthRef),
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
    return _EnsureGroupChatMemberAuthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnsureGroupChatMemberAuthProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EnsureGroupChatMemberAuthRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _EnsureGroupChatMemberAuthProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with EnsureGroupChatMemberAuthRef {
  _EnsureGroupChatMemberAuthProviderElement(super.provider);

  @override
  String get journeyId =>
      (origin as EnsureGroupChatMemberAuthProvider).journeyId;
}

String _$groupChatMessagesHash() => r'979e2d98454e20ba80fe2dd51a24255bd8def531';

/// See also [groupChatMessages].
@ProviderFor(groupChatMessages)
const groupChatMessagesProvider = GroupChatMessagesFamily();

/// See also [groupChatMessages].
class GroupChatMessagesFamily
    extends Family<AsyncValue<List<GroupMessageEntity>>> {
  /// See also [groupChatMessages].
  const GroupChatMessagesFamily();

  /// See also [groupChatMessages].
  GroupChatMessagesProvider call(
    String journeyId,
  ) {
    return GroupChatMessagesProvider(
      journeyId,
    );
  }

  @override
  GroupChatMessagesProvider getProviderOverride(
    covariant GroupChatMessagesProvider provider,
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
  String? get name => r'groupChatMessagesProvider';
}

/// See also [groupChatMessages].
class GroupChatMessagesProvider
    extends AutoDisposeStreamProvider<List<GroupMessageEntity>> {
  /// See also [groupChatMessages].
  GroupChatMessagesProvider(
    String journeyId,
  ) : this._internal(
          (ref) => groupChatMessages(
            ref as GroupChatMessagesRef,
            journeyId,
          ),
          from: groupChatMessagesProvider,
          name: r'groupChatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupChatMessagesHash,
          dependencies: GroupChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              GroupChatMessagesFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  GroupChatMessagesProvider._internal(
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
    Stream<List<GroupMessageEntity>> Function(GroupChatMessagesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupChatMessagesProvider._internal(
        (ref) => create(ref as GroupChatMessagesRef),
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
  AutoDisposeStreamProviderElement<List<GroupMessageEntity>> createElement() {
    return _GroupChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupChatMessagesProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupChatMessagesRef
    on AutoDisposeStreamProviderRef<List<GroupMessageEntity>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _GroupChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<GroupMessageEntity>>
    with GroupChatMessagesRef {
  _GroupChatMessagesProviderElement(super.provider);

  @override
  String get journeyId => (origin as GroupChatMessagesProvider).journeyId;
}

String _$groupChatReadyHash() => r'f38fdb6c973c7c9c0dba9035d5d0352e61be3dd9';

/// See also [groupChatReady].
@ProviderFor(groupChatReady)
const groupChatReadyProvider = GroupChatReadyFamily();

/// See also [groupChatReady].
class GroupChatReadyFamily extends Family<bool> {
  /// See also [groupChatReady].
  const GroupChatReadyFamily();

  /// See also [groupChatReady].
  GroupChatReadyProvider call(
    String journeyId,
  ) {
    return GroupChatReadyProvider(
      journeyId,
    );
  }

  @override
  GroupChatReadyProvider getProviderOverride(
    covariant GroupChatReadyProvider provider,
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
  String? get name => r'groupChatReadyProvider';
}

/// See also [groupChatReady].
class GroupChatReadyProvider extends AutoDisposeProvider<bool> {
  /// See also [groupChatReady].
  GroupChatReadyProvider(
    String journeyId,
  ) : this._internal(
          (ref) => groupChatReady(
            ref as GroupChatReadyRef,
            journeyId,
          ),
          from: groupChatReadyProvider,
          name: r'groupChatReadyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupChatReadyHash,
          dependencies: GroupChatReadyFamily._dependencies,
          allTransitiveDependencies:
              GroupChatReadyFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  GroupChatReadyProvider._internal(
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
    bool Function(GroupChatReadyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupChatReadyProvider._internal(
        (ref) => create(ref as GroupChatReadyRef),
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
    return _GroupChatReadyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupChatReadyProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupChatReadyRef on AutoDisposeProviderRef<bool> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _GroupChatReadyProviderElement extends AutoDisposeProviderElement<bool>
    with GroupChatReadyRef {
  _GroupChatReadyProviderElement(super.provider);

  @override
  String get journeyId => (origin as GroupChatReadyProvider).journeyId;
}

String _$groupChatNotifierHash() => r'df46877836a284eea7e3f4f4c988c03b97bc847e';

abstract class _$GroupChatNotifier extends BuildlessAutoDisposeNotifier<void> {
  late final String journeyId;

  void build(
    String journeyId,
  );
}

/// See also [GroupChatNotifier].
@ProviderFor(GroupChatNotifier)
const groupChatNotifierProvider = GroupChatNotifierFamily();

/// See also [GroupChatNotifier].
class GroupChatNotifierFamily extends Family<void> {
  /// See also [GroupChatNotifier].
  const GroupChatNotifierFamily();

  /// See also [GroupChatNotifier].
  GroupChatNotifierProvider call(
    String journeyId,
  ) {
    return GroupChatNotifierProvider(
      journeyId,
    );
  }

  @override
  GroupChatNotifierProvider getProviderOverride(
    covariant GroupChatNotifierProvider provider,
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
  String? get name => r'groupChatNotifierProvider';
}

/// See also [GroupChatNotifier].
class GroupChatNotifierProvider
    extends AutoDisposeNotifierProviderImpl<GroupChatNotifier, void> {
  /// See also [GroupChatNotifier].
  GroupChatNotifierProvider(
    String journeyId,
  ) : this._internal(
          () => GroupChatNotifier()..journeyId = journeyId,
          from: groupChatNotifierProvider,
          name: r'groupChatNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupChatNotifierHash,
          dependencies: GroupChatNotifierFamily._dependencies,
          allTransitiveDependencies:
              GroupChatNotifierFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  GroupChatNotifierProvider._internal(
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
    covariant GroupChatNotifier notifier,
  ) {
    return notifier.build(
      journeyId,
    );
  }

  @override
  Override overrideWith(GroupChatNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GroupChatNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<GroupChatNotifier, void> createElement() {
    return _GroupChatNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupChatNotifierProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupChatNotifierRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _GroupChatNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<GroupChatNotifier, void>
    with GroupChatNotifierRef {
  _GroupChatNotifierProviderElement(super.provider);

  @override
  String get journeyId => (origin as GroupChatNotifierProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
