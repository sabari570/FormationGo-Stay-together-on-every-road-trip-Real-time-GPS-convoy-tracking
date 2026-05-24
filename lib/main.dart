import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/device_identity_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Initialize Firebase (wrapped in try-catch in case google-services.json is not configured yet)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed: $e. Make sure google-services.json is added.');
  }

  // Initialize SharedPreferences
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
      designSize: const Size(390, 844), // iPhone 14 Pro logical resolution
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'FormationGo',
          theme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Enforce dark theme
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
