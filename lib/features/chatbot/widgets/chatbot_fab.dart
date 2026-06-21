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
    final isReady = ref.watch(chatbotReadyProvider(journeyId));
    final indexingFailed = ref.watch(chatbotIndexingFailedProvider(journeyId));
    final aiEnabled = ref.watch(chatbotAiEnabledProvider);

    // Hidden while route places are being indexed.
    if (!isReady && !indexingFailed) {
      return const SizedBox.shrink();
    }

    final modeLabel = aiEnabled ? 'AI' : 'Local';
    final modeColor = aiEnabled ? AppColors.convoyGreen : AppColors.convoyAmber;

    if (indexingFailed) {
      return FloatingActionButton.extended(
        heroTag: 'chatbot_fab',
        extendedPadding: EdgeInsets.symmetric(horizontal: 12.w),
        backgroundColor: AppColors.bg1,
        shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
        icon: Icon(Icons.refresh, color: AppColors.convoyRed, size: 18.sp),
        label: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Tour Guide  ',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  height: 1.0,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.convoyRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                    border:
                        Border.all(color: AppColors.convoyRed.withOpacity(0.5)),
                  ),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppColors.convoyRed,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onPressed: () => ref.read(retryRoutePoiIndexingProvider(journeyId)),
      );
    }

    return FloatingActionButton.extended(
      heroTag: 'chatbot_fab',
      extendedPadding: EdgeInsets.symmetric(horizontal: 12.w),
      backgroundColor: AppColors.convoyBlue,
      icon: Icon(Icons.assistant, color: Colors.white, size: 18.sp),
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Ask Tour Guide  ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                height: 1.0,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: modeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: modeColor.withOpacity(0.5)),
                ),
                child: Text(
                  modeLabel,
                  style: TextStyle(
                    color: modeColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () => context.push('/journey/$journeyId/chat'),
    );
  }
}
