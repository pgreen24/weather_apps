import 'package:flutter/material.dart';

import '../../apps_color.dart';

class WTextTheme {
  WTextTheme._();

  static const double _mobileMaxWidth = 600;
  static const double _tabletMaxWidth = 1024;

  static double _scaleFactor(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width <= _mobileMaxWidth) {
      return (width / 375).clamp(0.9, 1.05);
    } else if (width <= _tabletMaxWidth) {
      return (width / 600).clamp(1.05, 1.2);
    } else {
      return 1.2;
    }
  }

  static double _fs(BuildContext context, double base) {
    return (base * _scaleFactor(context));
  }

  // ---------------- LIGHT ----------------
  static TextTheme lightTextTheme(BuildContext context) {
    return TextTheme(
      // Headlines
      headlineLarge: TextStyle(
        fontSize: _fs(context, 28),
        fontWeight: FontWeight.bold,
        color: AppsColor.dark,
      ),
      headlineMedium: TextStyle(
        fontSize: _fs(context, 22),
        fontWeight: FontWeight.w700,
        color: AppsColor.dark,
      ),
      headlineSmall: TextStyle(
        fontSize: _fs(context, 18),
        fontWeight: FontWeight.w600,
        color: AppsColor.dark,
      ),

      // Titles
      titleLarge: TextStyle(
        fontSize: _fs(context, 16),
        fontWeight: FontWeight.w600,
        color: AppsColor.dark,
      ),
      titleMedium: TextStyle(
        fontSize: _fs(context, 15),
        fontWeight: FontWeight.w500,
        color: AppsColor.dark,
      ),
      titleSmall: TextStyle(
        fontSize: _fs(context, 14),
        fontWeight: FontWeight.w500,
        color: AppsColor.dark,
      ),

      // Body
      bodyLarge: TextStyle(
        fontSize: _fs(context, 15),
        fontWeight: FontWeight.w400,
        color: AppsColor.dark,
      ),
      bodyMedium: TextStyle(
        fontSize: _fs(context, 14),
        fontWeight: FontWeight.w400,
        color: AppsColor.dark,
      ),
      bodySmall: TextStyle(
        fontSize: _fs(context, 13),
        fontWeight: FontWeight.w400,
        color: AppsColor.dark,
      ),

      // Labels / captions
      labelLarge: TextStyle(
        fontSize: _fs(context, 14),
        fontWeight: FontWeight.w500,
        color: AppsColor.dark,
      ),
      labelMedium: TextStyle(
        fontSize: _fs(context, 12),
        fontWeight: FontWeight.w400,
        color: AppsColor.dark,
      ),
      labelSmall: TextStyle(
        fontSize: _fs(context, 11),
        fontWeight: FontWeight.w400,
        color: AppsColor.dark,
      ),
    );
  }

  // ---------------- DARK ----------------
  static TextTheme darkTextTheme(BuildContext context) {
    return lightTextTheme(context).apply(
      bodyColor: AppsColor.light,
      displayColor: AppsColor.light,
    );
  }
}