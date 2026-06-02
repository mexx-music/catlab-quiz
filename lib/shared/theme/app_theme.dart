import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFFF8C69);
  static const Color secondary = Color(0xFFFFF3E0);
  static const Color correct = Color(0xFF66BB6A);
  static const Color wrong = Color(0xFFEF5350);
  static const Color textDark = Color(0xFF3E2723);

  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primary, surface: secondary),
      scaffoldBackgroundColor: secondary,
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
