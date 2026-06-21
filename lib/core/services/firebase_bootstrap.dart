import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Initializes Firebase and signs in anonymously so Firestore rules pass.
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser != null) {
    debugPrint('Firebase: already signed in (${FirebaseAuth.instance.currentUser!.uid})');
    return;
  }

  final credential = await FirebaseAuth.instance.signInAnonymously();
  debugPrint('Firebase: anonymous sign-in OK (${credential.user?.uid})');
}
