import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {

  // =========================
  // LIGHT THEME
  // =========================

  static ThemeData
  lightTheme = ThemeData(

    useMaterial3: true,

    brightness:
    Brightness.light,

    scaffoldBackgroundColor:
    const Color(0xFFF8FAFC),

    primaryColor:
    AppColors.primary,

    fontFamily:
    "Roboto",

    appBarTheme:
    const AppBarTheme(

      backgroundColor:
      Colors.transparent,

      foregroundColor:
      Colors.black,

      elevation: 0,

      centerTitle: true,

    ),

    cardTheme:
    CardThemeData(

      color:
      Colors.white,

      elevation: 8,

      shadowColor:
      Colors.black12,

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(25),

      ),

    ),

    // =========================
    // BUTTON THEME
    // =========================

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,

        elevation: 0,

        // FIXED ERROR
        minimumSize:
        const Size(
          0,
          58,
        ),

        padding:
        const EdgeInsets.symmetric(

          horizontal: 20,

          vertical: 16,

        ),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(22),

        ),

        textStyle:
        const TextStyle(

          fontSize: 18,

          fontWeight:
          FontWeight.bold,

        ),

      ),

    ),

    // =========================
    // INPUT THEME
    // =========================

    inputDecorationTheme:
    InputDecorationTheme(

      filled: true,

      fillColor:
      Colors.white,

      hintStyle:
      const TextStyle(

        color:
        Colors.grey,

      ),

      contentPadding:
      const EdgeInsets.symmetric(

        horizontal: 20,

        vertical: 18,

      ),

      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(22),

        borderSide:
        BorderSide.none,

      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(22),

        borderSide:
        BorderSide.none,

      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(22),

        borderSide:
        const BorderSide(

          color:
          AppColors.primary,

          width: 2,

        ),

      ),

    ),

  );

  // =========================
  // DARK THEME
  // =========================

  static ThemeData
  darkTheme = ThemeData(

    useMaterial3: true,

    brightness:
    Brightness.dark,

    scaffoldBackgroundColor:
    const Color(0xFF0F172A),

    primaryColor:
    AppColors.primary,

    fontFamily:
    "Roboto",

    appBarTheme:
    const AppBarTheme(

      backgroundColor:
      Colors.transparent,

      foregroundColor:
      Colors.white,

      elevation: 0,

      centerTitle: true,

    ),

    // =========================
    // CARD THEME
    // =========================

    cardTheme:
    CardThemeData(

      color:
      const Color(0xFF1E293B),

      elevation: 0,

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(25),

      ),

    ),

    // =========================
    // BUTTON THEME
    // =========================

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,

        elevation: 0,

        // FIXED ERROR
        minimumSize:
        const Size(
          0,
          58,
        ),

        padding:
        const EdgeInsets.symmetric(

          horizontal: 20,

          vertical: 16,

        ),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(22),

        ),

        textStyle:
        const TextStyle(

          fontSize: 18,

          fontWeight:
          FontWeight.bold,

        ),

      ),

    ),

    // =========================
    // INPUT THEME
    // =========================

    inputDecorationTheme:
    InputDecorationTheme(

      filled: true,

      fillColor:
      const Color(0xFF1E293B),

      hintStyle:
      const TextStyle(

        color:
        Colors.white54,

      ),

      contentPadding:
      const EdgeInsets.symmetric(

        horizontal: 20,

        vertical: 18,

      ),

      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(22),

        borderSide:
        BorderSide.none,

      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(22),

        borderSide:
        BorderSide.none,

      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(22),

        borderSide:
        const BorderSide(

          color:
          AppColors.primary,

          width: 2,

        ),

      ),

    ),

    // =========================
    // TEXT THEME
    // =========================

    textTheme:
    const TextTheme(

      bodyLarge:
      TextStyle(

        color:
        Colors.white,

      ),

      bodyMedium:
      TextStyle(

        color:
        Colors.white70,

      ),

      titleLarge:
      TextStyle(

        color:
        Colors.white,

        fontWeight:
        FontWeight.bold,

      ),

    ),

    // =========================
    // ICON THEME
    // =========================

    iconTheme:
    const IconThemeData(

      color:
      Colors.white,

    ),

  );

}