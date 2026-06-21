import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/group_message.dart';

class GroupMessageBubble extends StatelessWidget {
  final GroupMessageEntity message;
  final bool isMine;

  const GroupMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  Color get _avatarColor {
    final hex = message.senderAvatarColor.replaceFirst('#', '');
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.convoyBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 6.h,
          bottom: 6.h,
          left: isMine ? 50.w : 16.w,
          right: isMine ? 16.w : 50.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.convoyBlue.withOpacity(0.18)
              : AppColors.bg1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMine ? 16.r : 2.r),
            bottomRight: Radius.circular(isMine ? 2.r : 16.r),
          ),
          border: Border.all(
            color: isMine
                ? AppColors.convoyBlue.withOpacity(0.4)
                : AppColors.border.withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10.r,
                  backgroundColor: _avatarColor,
                  child: Text(
                    message.senderName.isNotEmpty
                        ? message.senderName.substring(0, 1).toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  isMine ? 'You' : message.senderName,
                  style: TextStyle(
                    color: isMine ? AppColors.convoyBlue : Colors.white70,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              message.content,
              style: TextStyle(
                color: message.decryptFailed
                    ? AppColors.convoyAmber
                    : Colors.white.withOpacity(0.95),
                fontSize: 14.sp,
                height: 1.4,
                fontStyle:
                    message.decryptFailed ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTime(message.createdAt),
                style: TextStyle(fontSize: 8.sp, color: Colors.white38),
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
