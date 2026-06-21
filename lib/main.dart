import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/firebase_bootstrap.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/device_identity_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env: $e');
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await initializeFirebase();
  } on FirebaseException catch (e) {
    debugPrint('Firebase error [${e.code}]: ${e.message}');
    if (e.code == 'operation-not-allowed') {
      debugPrint(
        'Enable Anonymous sign-in: Firebase Console → Authentication → Sign-in method → Anonymous → Enable',
      );
    }
  } catch (e, st) {
    debugPrint('Firebase init failed: $e\n$st');
    debugPrint('See FIREBASE_SETUP.md if google-services.json or rules are not configured.');
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const FormationGoApp(),
  ));
}

class FormationGoApp extends ConsumerWidget {
  const FormationGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'FormationGo',
          theme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
