import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';

class InviteSheet extends StatelessWidget {
  final String journeyName;
  final String passCode;

  const InviteSheet({
    super.key,
    required this.journeyName,
    required this.passCode,
  });

  void _shareInvite() {
    final message = 'Join my convoy on FormationGo!\n'
        'Journey: $journeyName\n'
        'Passcode: $passCode\n\n'
        'Enter this passcode in the app to track each other in real-time!';
    
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Invite Members',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            journeyName,
            style: TextStyle(color: AppColors.convoyNeutral, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          
          // QR Code Card
          Center(
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.convoyBlue.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: QrImageView(
                data: passCode,
                version: QrVersions.auto,
                size: 180.w,
                gapless: false,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          
          // Passcode display box
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.bg1,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border, width: 1.w),
            ),
            child: Column(
              children: [
                Text(
                  'JOINING PASSCODE',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  passCode,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        color: AppColors.convoyGreen,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          
          // Share Button
          ElevatedButton.icon(
            onPressed: _shareInvite,
            icon: Icon(Icons.share, size: 20.w, color: Colors.white),
            label: Text(
              'Share Invitation',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.convoyBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
