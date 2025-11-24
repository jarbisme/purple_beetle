import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define a constant for border radius to be reused
  static const double borderRadius = 16.0;
  static const Color _primaryColor = Color(0xFF790C5A);
  static const Color _secondaryColor = Color(0xFFCC0E74);
  static const Color _primaryBackgroundColor = Color(0xFFF2E6E6);
  static const Color _secondaryBackgroundColor = Color(0xFFE6D0D8);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Define primary and secondary colors using a seed color
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryBackgroundColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      surface: _primaryBackgroundColor,
      surfaceContainerHigh: _secondaryBackgroundColor,
      secondary: _secondaryColor,
    ),
    // colorScheme: ColorScheme(primary: primaryColor, secondary: secondaryColor),

    // Define the default font family
    fontFamily: GoogleFonts.comfortaa().fontFamily,

    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _primaryColor),
    ),
    // Define background colors
    scaffoldBackgroundColor: _primaryBackgroundColor, // Primary background
    // Define component themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // Define button radius
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        textStyle: TextStyle(
          fontSize: 32,
          fontFamily: GoogleFonts.comfortaa().fontFamily,
          fontWeight: FontWeight.normal,
          color: _primaryColor,
        ),
      ),
    ),

    iconTheme: IconThemeData(color: _primaryColor, size: 30),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        textStyle: TextStyle(
          fontSize: 32,
          fontFamily: GoogleFonts.comfortaa().fontFamily,
          fontWeight: FontWeight.normal,
          color: _primaryColor,
        ),
      ),
    ),

    dividerTheme: DividerThemeData(color: _primaryColor.withValues(alpha: 0.3), thickness: 1),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),

    fontFamily: GoogleFonts.lato().fontFamily,

    scaffoldBackgroundColor: Colors.black,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
