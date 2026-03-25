// lib/core/theme/app_theme.dart
// Defines the app's visual theme matching the Figma design.
// Use the helper methods (textPrimary, textSecondary, cardColor) in widgets
// instead of hardcoding Colors.white — they return the right colour for
// both dark and light mode automatically.

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Brand colours ────────────────────────────────────────
  static const Color navyDark    = Color(0xFF0D0D2B);
  static const Color navyMid     = Color(0xFF1A1A3E);
  static const Color navyCard    = Color(0xFF1E2040);
  static const Color accentGreen  = Color(0xFF9DFF5B);
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color accentBlue   = Color(0xFF4FC3F7);
  static const Color textWhite    = Color(0xFFFFFFFF);
  static const Color textGrey     = Color(0xFFB0B0C0);

  // Light mode colours
  static const Color lightBg       = Color(0xFFF4F6FB);
  static const Color lightCard     = Color(0xFFFFFFFF);
  static const Color lightPrimary  = Color(0xFF3D3DBF);
  static const Color lightTextPri  = Color(0xFF0D0D2B);
  static const Color lightTextSec  = Color(0xFF6B7280);

  // ── Adaptive helpers ─────────────────────────────────────
  // Call these in widgets instead of hardcoding Colors.white.
  // Example:  color: AppTheme.textPrimary(context)

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

  static Color cardBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // ── Dark Theme ───────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: navyDark,
      primaryColor: accentBlue,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentGreen,
        surface: navyCard,
        background: navyDark,
        onPrimary: navyDark,
        onSecondary: navyDark,
        onSurface: textWhite,
        onBackground: textWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: navyDark,
        elevation: 0,
        iconTheme: IconThemeData(color: textWhite),
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: navyCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3D3DBF),
          foregroundColor: textWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: navyCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2A5A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        labelStyle: const TextStyle(color: textGrey),
        hintStyle: const TextStyle(color: textGrey),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navyMid,
        selectedItemColor: accentGreen,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textWhite, fontSize: 28, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textWhite, fontSize: 22, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textWhite, fontSize: 16),
        bodyMedium: TextStyle(color: textGrey, fontSize: 14),
        labelLarge: TextStyle(color: textWhite, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      dividerColor: const Color(0xFF2A2A5A),
    );
  }

  // ── Light Theme ──────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      primaryColor: lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: Color(0xFF2A9D8F),
        surface: lightCard,
        background: lightBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPri,      // ← used by textPrimary()
        onBackground: lightTextPri,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightCard,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPri),
        titleTextStyle: TextStyle(
          color: lightTextPri,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE2EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        labelStyle: const TextStyle(color: lightTextSec),
        hintStyle: const TextStyle(color: lightTextSec),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightCard,
        selectedItemColor: lightPrimary,
        unselectedItemColor: lightTextSec,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: lightTextPri, fontSize: 28, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: lightTextPri, fontSize: 22, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: lightTextPri, fontSize: 16),
        bodyMedium: TextStyle(color: lightTextSec, fontSize: 14),
        labelLarge: TextStyle(color: lightTextPri, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      dividerColor: const Color(0xFFE5E7EB),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? lightPrimary
              : Colors.grey,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? lightPrimary.withOpacity(0.4)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }
}
