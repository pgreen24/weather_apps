import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_apps/utils/theme/widgets_theme/input_decoration_theme.dart';


class WAppTheme {
  WAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),

      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: WInputDecorationTheme.lightInputDecorationTheme
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

      scaffoldBackgroundColor: Colors.black,
      inputDecorationTheme: WInputDecorationTheme.darkInputDecorationTheme
  );

  static bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

}