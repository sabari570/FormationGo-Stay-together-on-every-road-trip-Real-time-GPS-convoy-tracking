// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthStateHash() => r'ed6ea7da536934c6d1fef77f43c82941e92da10a';

/// See also [firebaseAuthState].
@ProviderFor(firebaseAuthState)
final firebaseAuthStateProvider = StreamProvider<User?>.internal(
  firebaseAuthState,
  name: r'firebaseAuthStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseAuthStateRef = StreamProviderRef<User?>;
String _$firebaseAuthReadyHash() => r'319c2a67da10b92978a23e228a42826b0a943b96';

/// See also [firebaseAuthReady].
@ProviderFor(firebaseAuthReady)
final firebaseAuthReadyProvider = FutureProvider<User?>.internal(
  firebaseAuthReady,
  name: r'firebaseAuthReadyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthReadyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseAuthReadyRef = FutureProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
