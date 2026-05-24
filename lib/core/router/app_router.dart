import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/device_identity_provider.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/profile_creation_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/journey_management/screens/create_journey_screen.dart';
import '../../features/journey_management/screens/join_journey_screen.dart';
import '../../features/journey_management/screens/journey_dashboard_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final deviceIdentityService = ref.watch(deviceIdentityServiceProvider);
  final isFirstTime = !deviceIdentityService.hasCompletedOnboarding();

  return GoRouter(
    initialLocation: isFirstTime ? '/onboarding' : '/',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileCreationScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/create-journey',
        builder: (context, state) => const CreateJourneyScreen(),
      ),
      GoRoute(
        path: '/join-journey',
        builder: (context, state) => const JoinJourneyScreen(),
      ),
      GoRoute(
        path: '/journey/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return JourneyDashboardScreen(journeyId: id);
        },
      ),
    ],
  );
}
