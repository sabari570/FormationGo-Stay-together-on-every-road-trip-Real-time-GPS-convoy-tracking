import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final isThinking = message.content == 'Thinking...';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 6.h,
          bottom: 6.h,
          left: isUser ? 50.w : 16.w,
          right: isUser ? 16.w : 50.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser ? AppColors.convoyBlue.withOpacity(0.15) : AppColors.bg1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isUser ? 16.r : 2.r),
            bottomRight: Radius.circular(isUser ? 2.r : 16.r),
          ),
          border: Border.all(
            color: isUser 
                ? AppColors.convoyBlue.withOpacity(0.4) 
                : AppColors.border.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender role label
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUser ? Icons.person : Icons.assistant,
                  size: 12.sp,
                  color: isUser ? AppColors.convoyBlue : AppColors.convoyGreen,
                ),
                SizedBox(width: 4.w),
                Text(
                  isUser ? 'You' : 'Tour Guide',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: isUser ? AppColors.convoyBlue : AppColors.convoyGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            
            // Content
            if (isThinking)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12.w,
                    height: 12.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.convoyGreen),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Thinking...',
                    style: TextStyle(
                      color: AppColors.convoyNeutral,
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else
              Text(
                message.content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 14.sp,
                  height: 1.45,
                ),
              ),
            
            SizedBox(height: 4.h),
            // Timestamp
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTime(message.createdAt),
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }
}
