import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/chatbot_provider.dart';

class ChatbotFab extends ConsumerWidget {
  final String journeyId;

  const ChatbotFab({super.key, required this.journeyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReadyAsync = ref.watch(chatbotReadyProvider(journeyId));

    return isReadyAsync.when(
      data: (ready) {
        if (ready) {
          // Dynamic glowing state indicating tour guide is ready!
          return FloatingActionButton.extended(
            heroTag: 'chatbot_fab_active',
            backgroundColor: AppColors.convoyBlue,
            icon: Icon(
              Icons.assistant,
              color: Colors.white,
              size: 20.sp,
            ),
            label: Text(
              'Ask Tour Guide',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
            onPressed: () {
              context.push('/journey/$journeyId/chat');
            },
          );
        } else {
          // Locked/Processing state: parsing route to populate database
          return FloatingActionButton.extended(
            heroTag: 'chatbot_fab_loading',
            backgroundColor: AppColors.bg1,
            shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
            icon: SizedBox(
              width: 14.w,
              height: 14.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.convoyAmber),
              ),
            ),
            label: Text(
              'Caching Route POIs...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11.sp,
              ),
            ),
            onPressed: null, // Disabled
          );
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
