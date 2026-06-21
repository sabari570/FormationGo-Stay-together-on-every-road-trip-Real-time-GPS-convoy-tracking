import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> firebaseAuthState(FirebaseAuthStateRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@Riverpod(keepAlive: true)
Future<User?> firebaseAuthReady(FirebaseAuthReadyRef ref) async {
  final current = FirebaseAuth.instance.currentUser;
  if (current != null) return current;

  await for (final user in FirebaseAuth.instance.authStateChanges()) {
    if (user != null) return user;
  }

  return null;
}
