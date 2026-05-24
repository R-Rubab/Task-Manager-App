import 'package:flutter/material.dart';

class CColors {
  CColors._();
  static const Color primaryColor = Color(0xFF5B5B5B);
    // ── Constants Splash Screen ──────────────────────────────────────────────────────────────
  static const Duration splashDuration = Duration(seconds: 6);
  static const Duration fadeDuration = Duration(milliseconds: 800);

  static const Color gradientStart = Color(0xFF764DBD);
  static const Color gradientEnd = Color(0xFFCD53E2);
    // ── Constants Login Screen ──────────────────────────────────────────────────────────────
  static const gradientColors = [Color(0xFF6A1B9A), Color(0xFFAB47BC)];
  static const cardRadius = 24.0;
  static const fieldRadius = 14.0;
  static const animDuration = Duration(milliseconds: 600);


    // ── Constants Home Screen ──────────────────────────────────────────────────────────────
  // static const gradientColors = [Color(0xFF6A1B9A), Color(0xFFAB47BC)];
  static const sheetRadius = Radius.circular(24.0);
  static const cardBorderRadius = BorderRadius.all(Radius.circular(20));




}