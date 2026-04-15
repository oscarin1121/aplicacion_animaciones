import 'package:flutter/material.dart';

class AppTypography {
  static const bodyFontFamily = 'Inter';
  static const displayFontFamily = 'NotoSerif';

  static TextTheme textTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: displayFontFamily,
        fontWeight: FontWeight.w300,
        fontSize: 62,
        height: 1.04,
        letterSpacing: -2,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFontFamily,
        fontWeight: FontWeight.w300,
        fontSize: 52,
        height: 1.06,
        letterSpacing: -1.4,
      ),
      headlineLarge: TextStyle(
        fontFamily: displayFontFamily,
        fontWeight: FontWeight.w300,
        fontSize: 42,
        height: 1.08,
        letterSpacing: -1,
      ),
      headlineMedium: TextStyle(
        fontFamily: displayFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 32,
        height: 1.1,
      ),
      titleLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.2,
      ),
      titleMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 15,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.45,
      ),
      labelLarge: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.2,
        letterSpacing: 0.3,
      ),
      labelMedium: TextStyle(
        fontFamily: bodyFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1.25,
        letterSpacing: 1.4,
      ),
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
  }
}
