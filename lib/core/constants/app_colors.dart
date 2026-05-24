import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color convoyGreen = Color(0xFF00E676);   // member IN range
  static const Color convoyAmber = Color(0xFFFFC400);   // member APPROACHING limit
  static const Color convoyRed = Color(0xFFFF1744);     // member OUT of range
  static const Color convoyBlue = Color(0xFF2979FF);    // checkpoints, active elements
  static const Color convoyNeutral = Color(0xFF90CAF9); // labels, secondary text

  // Background layers
  static const Color bg0 = Color(0xFF0A0E1A); // deepest background
  static const Color bg1 = Color(0xFF111827); // card backgrounds
  static const Color bg2 = Color(0xFF1C2536); // elevated surfaces
  static const Color border = Color(0xFF2A3550); // subtle dividers
}
