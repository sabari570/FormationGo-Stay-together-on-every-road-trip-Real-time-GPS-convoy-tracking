// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatbot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placesServiceHash() => r'57530c7732326fd6adce5598366a6a7fa6a4620e';

/// See also [placesService].
@ProviderFor(placesService)
final placesServiceProvider = AutoDisposeProvider<PlacesService>.internal(
  placesService,
  name: r'placesServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$placesServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlacesServiceRef = AutoDisposeProviderRef<PlacesService>;
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
String _$geminiServiceHash() => r'64d95d24f6661b758c8da4b62b7fe688b692898e';

/// See also [geminiService].
@ProviderFor(geminiService)
final geminiServiceProvider = AutoDisposeProvider<GeminiService>.internal(
  geminiService,
  name: r'geminiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$geminiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GeminiServiceRef = AutoDisposeProviderRef<GeminiService>;
String _$routePipelineServiceHash() =>
    r'311a6a2811a292073cfe5ef59f0389bbe5460106';

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
String _$chatbotReadyHash() => r'fbf96391d6a7ace07c3a05382a530df7ab11725d';

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

/// See also [chatbotReady].
@ProviderFor(chatbotReady)
const chatbotReadyProvider = ChatbotReadyFamily();

/// See also [chatbotReady].
class ChatbotReadyFamily extends Family<AsyncValue<bool>> {
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
class ChatbotReadyProvider extends AutoDisposeStreamProvider<bool> {
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
    Stream<bool> Function(ChatbotReadyRef provider) create,
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
  AutoDisposeStreamProviderElement<bool> createElement() {
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

mixin ChatbotReadyRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _ChatbotReadyProviderElement
    extends AutoDisposeStreamProviderElement<bool> with ChatbotReadyRef {
  _ChatbotReadyProviderElement(super.provider);

  @override
  String get journeyId => (origin as ChatbotReadyProvider).journeyId;
}

String _$chatbotMessagesNotifierHash() =>
    r'2016a46c6333b37453b31ba6d59956d186f90a10';

abstract class _$ChatbotMessagesNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<ChatMessage>> {
  late final String journeyId;

  FutureOr<List<ChatMessage>> build(
    String journeyId,
  );
}

/// See also [ChatbotMessagesNotifier].
@ProviderFor(ChatbotMessagesNotifier)
const chatbotMessagesNotifierProvider = ChatbotMessagesNotifierFamily();

/// See also [ChatbotMessagesNotifier].
class ChatbotMessagesNotifierFamily
    extends Family<AsyncValue<List<ChatMessage>>> {
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
    extends AutoDisposeAsyncNotifierProviderImpl<ChatbotMessagesNotifier,
        List<ChatMessage>> {
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
  FutureOr<List<ChatMessage>> runNotifierBuild(
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
  AutoDisposeAsyncNotifierProviderElement<ChatbotMessagesNotifier,
      List<ChatMessage>> createElement() {
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
    on AutoDisposeAsyncNotifierProviderRef<List<ChatMessage>> {
  /// The parameter `journeyId` of this provider.
  String get journeyId;
}

class _ChatbotMessagesNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatbotMessagesNotifier,
        List<ChatMessage>> with ChatbotMessagesNotifierRef {
  _ChatbotMessagesNotifierProviderElement(super.provider);

  @override
  String get journeyId => (origin as ChatbotMessagesNotifierProvider).journeyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
