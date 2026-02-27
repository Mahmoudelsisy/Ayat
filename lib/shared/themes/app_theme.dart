import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color islamicGreen = Color(0xFF1B5E20);
  static const Color calmBlue = Color(0xFF0D47A1);

  static ThemeData lightTheme(Color seed) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        primary: seed,
        secondary: calmBlue,
      ),
      textTheme: GoogleFonts.cairoTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: islamicGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }

  static ThemeData darkTheme(Color seed) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
        primary: seed,
        secondary: calmBlue,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}
