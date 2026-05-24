import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg0,
      primaryColor: AppColors.convoyGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.convoyGreen,
        secondary: AppColors.convoyBlue,
        surface: AppColors.bg1,
        error: AppColors.convoyRed,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: GoogleFonts.orbitron(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 16.sp, color: Colors.white),
        bodyMedium: GoogleFonts.inter(fontSize: 14.sp, color: Colors.white70),
        labelLarge: GoogleFonts.spaceMono(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white), // for numeric readouts
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: AppColors.bg1,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.convoyGreen,
          foregroundColor: AppColors.bg0,
          textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.convoyBlue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
