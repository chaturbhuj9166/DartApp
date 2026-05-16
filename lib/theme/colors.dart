import 'package:flutter/material.dart';

class AppColors {

  // =========================
  // PRIMARY COLORS
  // =========================

  static const Color primary =
  Color(0xFF2563EB);

  static const Color secondary =
  Color(0xFF06B6D4);

  static const Color accent =
  Color(0xFF3B82F6);

  // =========================
  // DARK BACKGROUND
  // =========================

  static const Color background =
  Color(0xFF0F172A);

  static const Color card =
  Color(0xFF1E293B);

  static const Color darkCard =
  Color(0xFF111827);

  static const Color glass =
  Color(0x33FFFFFF);

  // =========================
  // TEXT COLORS
  // =========================

  static const Color white =
  Colors.white;

  static const Color lightText =
  Color(0xFFCBD5E1);

  static const Color grey =
  Color(0xFF94A3B8);

  static const Color black =
  Colors.black;

  // =========================
  // STATUS COLORS
  // =========================

  static const Color success =
  Color(0xFF22C55E);

  static const Color error =
  Color(0xFFEF4444);

  static const Color warning =
  Color(0xFFF59E0B);

  static const Color info =
  Color(0xFF0EA5E9);

  // =========================
  // ATTENDANCE COLORS
  // =========================

  static const Color present =
  Color(0xFF10B981);

  static const Color absent =
  Color(0xFFDC2626);

  static const Color late =
  Color(0xFFF59E0B);

  // =========================
  // GRADIENTS
  // =========================

  static const LinearGradient
  primaryGradient =
  LinearGradient(

    colors: [

      Color(0xFF2563EB),

      Color(0xFF06B6D4),

    ],

    begin:
    Alignment.topLeft,

    end:
    Alignment.bottomRight,

  );

  static const LinearGradient
  darkGradient =
  LinearGradient(

    colors: [

      Color(0xFF0F172A),

      Color(0xFF111827),

    ],

    begin:
    Alignment.topCenter,

    end:
    Alignment.bottomCenter,

  );

  static const LinearGradient
  successGradient =
  LinearGradient(

    colors: [

      Color(0xFF22C55E),

      Color(0xFF16A34A),

    ],

  );

  static const LinearGradient
  warningGradient =
  LinearGradient(

    colors: [

      Color(0xFFF59E0B),

      Color(0xFFD97706),

    ],

  );

  static const LinearGradient
  dangerGradient =
  LinearGradient(

    colors: [

      Color(0xFFEF4444),

      Color(0xFFDC2626),

    ],

  );

}