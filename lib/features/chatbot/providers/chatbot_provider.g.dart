// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatbot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$overpassServiceHash() => r'787fd5112db023fad5c629ff19eb4b4e3c8e7b64';

/// See also [overpassService].
@ProviderFor(overpassService)
final overpassServiceProvider = AutoDisposeProvider<OverpassService>.internal(
  overpassService,
  name: r'overpassServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overpassServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OverpassServiceRef = AutoDisposeProviderRef<OverpassService>;
String _$routeAssistantServiceHash() =>
    r'46d1f1729ef5d0b904ad93132d68affd2009d3d8';

/// See also [routeAssistantService].
@ProviderFor(routeAssistantService)
final routeAssistantServiceProvider =
    AutoDisposeProvider<RouteAssistantService>.internal(
  routeAssistantService,
  name: r'routeAssistantServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routeAssistantServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouteAssistantServiceRef
    = AutoDisposeProviderRef<RouteAssistantService>;
String _$routePipelineServiceHash() =>
    r'4d6bfe8ba25d2ef11e859559b1dceec6741f498e';

/// See also [routePipelineService].
@ProviderFor(routePipelineService)
final routePipelineServiceProvider =
    AutoDisposeProvider<RoutePipelineService>.internal(
  routePipelineService,
  name: r'routePipelineServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routePipelineServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RoutePipelineServiceRef = AutoDisposeProviderRef<RoutePipelineService>;
String _$chatbotAiEnabledHash() => r'0d590e1986e23787496e13ce537e332f37ec6081';

/// See also [chatbotAiEnabled].
@ProviderFor(chatbotAiEnabled)
final chatbotAiEnabledProvider = AutoDisposeProvider<bool>.internal(
  chatbotAiEnabled,
  name: r'chatbotAiEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatbotAiEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatbotAiEnabledRef = AutoDisposeProviderRef<bool>;
String _$routePoisHash() => r'c46980bff80cf82095c895cf0af295161592e98a';

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

/// See also [routePois].
@ProviderFor(routePois)
const routePoisProvider = RoutePoisFamily();

/// See also [routePois].
class RoutePoisFamily extends Family<AsyncValue<List<RoutePoiEntity>>> {
  /// See also [routePois].
  const RoutePoisFamily();

  /// See also [routePois].
  RoutePoisProvider call(
    String journeyId,
  ) {
    return RoutePoisProvider(
      journeyId,
    );
  }

  @override
  RoutePoisProvider getProviderOverride(
    covariant RoutePoisProvider provider,
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
  String? get name => r'routePoisProvider';
}

/// See also [routePois].
class RoutePoisProvider
    extends AutoDisposeStreamProvider<List<RoutePoiEntity>> {
  /// See also [routePois].
  RoutePoisProvider(
    String journeyId,
  ) : this._internal(
          (ref) => routePois(
            ref as RoutePoisRef,
            journeyId,
          ),
          from: routePoisProvider,
          name: r'routePoisProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routePoisHash,
          dependencies: RoutePoisFamily._dependencies,
          allTransitiveDependencies: RoutePoisFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  RoutePoisProvider._internal(
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
    Stream<List<RoutePoiEntity>> Function(RoutePoisRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoutePoisProvider._internal(
        (ref) => create(ref as RoutePoisRef),
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
  AutoDisposeStreamProviderElement<List<RoutePoiEntity>> createElement() {
    return _RoutePoisProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutePoisProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RoutePoisRef on AutoDisposeStreamProviderRef<List<RoutePoiEntity>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _RoutePoisProviderElement
    extends AutoDisposeStreamProviderElement<List<RoutePoiEntity>>
    with RoutePoisRef {
  _RoutePoisProviderElement(super.provider);

  @override
  String get journeyId => (origin as RoutePoisProvider).journeyId;
}

String _$chatbotReadyHash() => r'291671df083f5cabfae54c1203608006f7073244';

/// See also [chatbotReady].
@ProviderFor(chatbotReady)
const chatbotReadyProvider = ChatbotReadyFamily();

/// See also [chatbotReady].
class ChatbotReadyFamily extends Family<bool> {
  /// See also [chatbotReady].
  const ChatbotReadyFamily();

  /// See also [chatbotReady].
  ChatbotReadyProvider call(
    String journeyId,
  ) {
    return ChatbotReadyProvider(
      journeyId,
    );
  }

  @override
  ChatbotReadyProvider getProviderOverride(
    covariant ChatbotReadyProvider provider,
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
  String? get name => r'chatbotReadyProvider';
}

/// See also [chatbotReady].
class ChatbotReadyProvider extends AutoDisposeProvider<bool> {
  /// See also [chatbotReady].
  ChatbotReadyProvider(
    String journeyId,
  ) : this._internal(
          (ref) => chatbotReady(
            ref as ChatbotReadyRef,
            journeyId,
          ),
          from: chatbotReadyProvider,
          name: r'chatbotReadyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatbotReadyHash,
          dependencies: ChatbotReadyFamily._dependencies,
          allTransitiveDependencies:
              ChatbotReadyFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  ChatbotReadyProvider._internal(
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
    bool Function(ChatbotReadyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatbotReadyProvider._internal(
        (ref) => create(ref as ChatbotReadyRef),
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
    return _ChatbotReadyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatbotReadyProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatbotReadyRef on AutoDisposeProviderRef<bool> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _ChatbotReadyProviderElement extends AutoDisposeProviderElement<bool>
    with ChatbotReadyRef {
  _ChatbotReadyProviderElement(super.provider);

  @override
  String get journeyId => (origin as ChatbotReadyProvider).journeyId;
}

String _$chatbotPoisLoadingHash() =>
    r'63dac7423cc3ce32cf609acecaf17e45c56f5c21';

/// See also [chatbotPoisLoading].
@ProviderFor(chatbotPoisLoading)
const chatbotPoisLoadingProvider = ChatbotPoisLoadingFamily();

/// See also [chatbotPoisLoading].
class ChatbotPoisLoadingFamily extends Family<bool> {
  /// See also [chatbotPoisLoading].
  const ChatbotPoisLoadingFamily();

  /// See also [chatbotPoisLoading].
  ChatbotPoisLoadingProvider call(
    String journeyId,
  ) {
    return ChatbotPoisLoadingProvider(
      journeyId,
    );
  }

  @override
  ChatbotPoisLoadingProvider getProviderOverride(
    covariant ChatbotPoisLoadingProvider provider,
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
  String? get name => r'chatbotPoisLoadingProvider';
}

/// See also [chatbotPoisLoading].
class ChatbotPoisLoadingProvider extends AutoDisposeProvider<bool> {
  /// See also [chatbotPoisLoading].
  ChatbotPoisLoadingProvider(
    String journeyId,
  ) : this._internal(
          (ref) => chatbotPoisLoading(
            ref as ChatbotPoisLoadingRef,
            journeyId,
          ),
          from: chatbotPoisLoadingProvider,
          name: r'chatbotPoisLoadingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatbotPoisLoadingHash,
          dependencies: ChatbotPoisLoadingFamily._dependencies,
          allTransitiveDependencies:
              ChatbotPoisLoadingFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  ChatbotPoisLoadingProvider._internal(
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
    bool Function(ChatbotPoisLoadingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatbotPoisLoadingProvider._internal(
        (ref) => create(ref as ChatbotPoisLoadingRef),
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
    return _ChatbotPoisLoadingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatbotPoisLoadingProvider && other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatbotPoisLoadingRef on AutoDisposeProviderRef<bool> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _ChatbotPoisLoadingProviderElement
    extends AutoDisposeProviderElement<bool> with ChatbotPoisLoadingRef {
  _ChatbotPoisLoadingProviderElement(super.provider);

  @override
  String get journeyId => (origin as ChatbotPoisLoadingProvider).journeyId;
}

String _$chatbotIndexingFailedHash() =>
    r'ed99a318c7468fb07d7694160160bbba1ac57166';

/// See also [chatbotIndexingFailed].
@ProviderFor(chatbotIndexingFailed)
const chatbotIndexingFailedProvider = ChatbotIndexingFailedFamily();

/// See also [chatbotIndexingFailed].
class ChatbotIndexingFailedFamily extends Family<bool> {
  /// See also [chatbotIndexingFailed].
  const ChatbotIndexingFailedFamily();

  /// See also [chatbotIndexingFailed].
  ChatbotIndexingFailedProvider call(
    String journeyId,
  ) {
    return ChatbotIndexingFailedProvider(
      journeyId,
    );
  }

  @override
  ChatbotIndexingFailedProvider getProviderOverride(
    covariant ChatbotIndexingFailedProvider provider,
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
  String? get name => r'chatbotIndexingFailedProvider';
}

/// See also [chatbotIndexingFailed].
class ChatbotIndexingFailedProvider extends AutoDisposeProvider<bool> {
  /// See also [chatbotIndexingFailed].
  ChatbotIndexingFailedProvider(
    String journeyId,
  ) : this._internal(
          (ref) => chatbotIndexingFailed(
            ref as ChatbotIndexingFailedRef,
            journeyId,
          ),
          from: chatbotIndexingFailedProvider,
          name: r'chatbotIndexingFailedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatbotIndexingFailedHash,
          dependencies: ChatbotIndexingFailedFamily._dependencies,
          allTransitiveDependencies:
              ChatbotIndexingFailedFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  ChatbotIndexingFailedProvider._internal(
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
    bool Function(ChatbotIndexingFailedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatbotIndexingFailedProvider._internal(
        (ref) => create(ref as ChatbotIndexingFailedRef),
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
    return _ChatbotIndexingFailedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatbotIndexingFailedProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatbotIndexingFailedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _ChatbotIndexingFailedProviderElement
    extends AutoDisposeProviderElement<bool> with ChatbotIndexingFailedRef {
  _ChatbotIndexingFailedProviderElement(super.provider);

  @override
  String get journeyId => (origin as ChatbotIndexingFailedProvider).journeyId;
}

String _$retryRoutePoiIndexingHash() =>
    r'c3027753c1c9c31e53d254b93e5de0a3a1ac5f75';

/// See also [retryRoutePoiIndexing].
@ProviderFor(retryRoutePoiIndexing)
const retryRoutePoiIndexingProvider = RetryRoutePoiIndexingFamily();

/// See also [retryRoutePoiIndexing].
class RetryRoutePoiIndexingFamily extends Family<AsyncValue<void>> {
  /// See also [retryRoutePoiIndexing].
  const RetryRoutePoiIndexingFamily();

  /// See also [retryRoutePoiIndexing].
  RetryRoutePoiIndexingProvider call(
    String journeyId,
  ) {
    return RetryRoutePoiIndexingProvider(
      journeyId,
    );
  }

  @override
  RetryRoutePoiIndexingProvider getProviderOverride(
    covariant RetryRoutePoiIndexingProvider provider,
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
  String? get name => r'retryRoutePoiIndexingProvider';
}

/// See also [retryRoutePoiIndexing].
class RetryRoutePoiIndexingProvider extends AutoDisposeFutureProvider<void> {
  /// See also [retryRoutePoiIndexing].
  RetryRoutePoiIndexingProvider(
    String journeyId,
  ) : this._internal(
          (ref) => retryRoutePoiIndexing(
            ref as RetryRoutePoiIndexingRef,
            journeyId,
          ),
          from: retryRoutePoiIndexingProvider,
          name: r'retryRoutePoiIndexingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$retryRoutePoiIndexingHash,
          dependencies: RetryRoutePoiIndexingFamily._dependencies,
          allTransitiveDependencies:
              RetryRoutePoiIndexingFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  RetryRoutePoiIndexingProvider._internal(
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
    FutureOr<void> Function(RetryRoutePoiIndexingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RetryRoutePoiIndexingProvider._internal(
        (ref) => create(ref as RetryRoutePoiIndexingRef),
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
    return _RetryRoutePoiIndexingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RetryRoutePoiIndexingProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RetryRoutePoiIndexingRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _RetryRoutePoiIndexingProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with RetryRoutePoiIndexingRef {
  _RetryRoutePoiIndexingProviderElement(super.provider);

  @override
  String get journeyId => (origin as RetryRoutePoiIndexingProvider).journeyId;
}

String _$routePoiIndexingStatusHash() =>
    r'0f1377abc9005e36cfa31332c51953907a414344';

abstract class _$RoutePoiIndexingStatus
    extends BuildlessAutoDisposeNotifier<RoutePoiIndexingState> {
  late final String journeyId;

  RoutePoiIndexingState build(
    String journeyId,
  );
}

/// See also [RoutePoiIndexingStatus].
@ProviderFor(RoutePoiIndexingStatus)
const routePoiIndexingStatusProvider = RoutePoiIndexingStatusFamily();

/// See also [RoutePoiIndexingStatus].
class RoutePoiIndexingStatusFamily extends Family<RoutePoiIndexingState> {
  /// See also [RoutePoiIndexingStatus].
  const RoutePoiIndexingStatusFamily();

  /// See also [RoutePoiIndexingStatus].
  RoutePoiIndexingStatusProvider call(
    String journeyId,
  ) {
    return RoutePoiIndexingStatusProvider(
      journeyId,
    );
  }

  @override
  RoutePoiIndexingStatusProvider getProviderOverride(
    covariant RoutePoiIndexingStatusProvider provider,
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
  String? get name => r'routePoiIndexingStatusProvider';
}

/// See also [RoutePoiIndexingStatus].
class RoutePoiIndexingStatusProvider extends AutoDisposeNotifierProviderImpl<
    RoutePoiIndexingStatus, RoutePoiIndexingState> {
  /// See also [RoutePoiIndexingStatus].
  RoutePoiIndexingStatusProvider(
    String journeyId,
  ) : this._internal(
          () => RoutePoiIndexingStatus()..journeyId = journeyId,
          from: routePoiIndexingStatusProvider,
          name: r'routePoiIndexingStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routePoiIndexingStatusHash,
          dependencies: RoutePoiIndexingStatusFamily._dependencies,
          allTransitiveDependencies:
              RoutePoiIndexingStatusFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  RoutePoiIndexingStatusProvider._internal(
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
  RoutePoiIndexingState runNotifierBuild(
    covariant RoutePoiIndexingStatus notifier,
  ) {
    return notifier.build(
      journeyId,
    );
  }

  @override
  Override overrideWith(RoutePoiIndexingStatus Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoutePoiIndexingStatusProvider._internal(
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
  AutoDisposeNotifierProviderElement<RoutePoiIndexingStatus,
      RoutePoiIndexingState> createElement() {
    return _RoutePoiIndexingStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutePoiIndexingStatusProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RoutePoiIndexingStatusRef
    on AutoDisposeNotifierProviderRef<RoutePoiIndexingState> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _RoutePoiIndexingStatusProviderElement
    extends AutoDisposeNotifierProviderElement<RoutePoiIndexingStatus,
        RoutePoiIndexingState> with RoutePoiIndexingStatusRef {
  _RoutePoiIndexingStatusProviderElement(super.provider);

  @override
  String get journeyId => (origin as RoutePoiIndexingStatusProvider).journeyId;
}

String _$chatbotMessagesNotifierHash() =>
    r'ce838833f3d0885a1af34c40a57a49f8caae4866';

abstract class _$ChatbotMessagesNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<ChatMessageEntity>> {
  late final String journeyId;

  Stream<List<ChatMessageEntity>> build(
    String journeyId,
  );
}

/// See also [ChatbotMessagesNotifier].
@ProviderFor(ChatbotMessagesNotifier)
const chatbotMessagesNotifierProvider = ChatbotMessagesNotifierFamily();

/// See also [ChatbotMessagesNotifier].
class ChatbotMessagesNotifierFamily
    extends Family<AsyncValue<List<ChatMessageEntity>>> {
  /// See also [ChatbotMessagesNotifier].
  const ChatbotMessagesNotifierFamily();

  /// See also [ChatbotMessagesNotifier].
  ChatbotMessagesNotifierProvider call(
    String journeyId,
  ) {
    return ChatbotMessagesNotifierProvider(
      journeyId,
    );
  }

  @override
  ChatbotMessagesNotifierProvider getProviderOverride(
    covariant ChatbotMessagesNotifierProvider provider,
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
  String? get name => r'chatbotMessagesNotifierProvider';
}

/// See also [ChatbotMessagesNotifier].
class ChatbotMessagesNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<ChatbotMessagesNotifier,
        List<ChatMessageEntity>> {
  /// See also [ChatbotMessagesNotifier].
  ChatbotMessagesNotifierProvider(
    String journeyId,
  ) : this._internal(
          () => ChatbotMessagesNotifier()..journeyId = journeyId,
          from: chatbotMessagesNotifierProvider,
          name: r'chatbotMessagesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatbotMessagesNotifierHash,
          dependencies: ChatbotMessagesNotifierFamily._dependencies,
          allTransitiveDependencies:
              ChatbotMessagesNotifierFamily._allTransitiveDependencies,
          journeyId: journeyId,
        );

  ChatbotMessagesNotifierProvider._internal(
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
  Stream<List<ChatMessageEntity>> runNotifierBuild(
    covariant ChatbotMessagesNotifier notifier,
  ) {
    return notifier.build(
      journeyId,
    );
  }

  @override
  Override overrideWith(ChatbotMessagesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatbotMessagesNotifierProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<ChatbotMessagesNotifier,
      List<ChatMessageEntity>> createElement() {
    return _ChatbotMessagesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatbotMessagesNotifierProvider &&
        other.journeyId == journeyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journeyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatbotMessagesNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<ChatMessageEntity>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _ChatbotMessagesNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ChatbotMessagesNotifier,
        List<ChatMessageEntity>> with ChatbotMessagesNotifierRef {
  _ChatbotMessagesNotifierProviderElement(super.provider);

  @override
  String get journeyId => (origin as ChatbotMessagesNotifierProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
