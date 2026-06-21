import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/device_identity_provider.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/profile_creation_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/journey_management/screens/create_journey_screen.dart';
import '../../features/journey_management/screens/join_journey_screen.dart';
import '../../features/journey_management/screens/journey_dashboard_screen.dart';
import '../../features/chatbot/screens/chatbot_screen.dart';
import '../../features/group_chat/screens/group_chat_screen.dart';

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
      GoRoute(
        path: '/journey/:id/chat',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChatbotScreen(journeyId: id);
        },
      ),
      GoRoute(
        path: '/journey/:id/group-chat',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GroupChatScreen(journeyId: id);
        },
      ),
    ],
  );
}
