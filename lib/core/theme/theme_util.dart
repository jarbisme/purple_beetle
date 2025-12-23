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

    // Define the default text theme
    textTheme: TextTheme(
      // Display styles - largest text (headlines, hero text)
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: _primaryColor),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: _primaryColor),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: _primaryColor),

      // Headline styles - section headers
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _primaryColor),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _primaryColor),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: _primaryColor),

      // Title styles - prominent text (app bars, list tiles)
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: _primaryColor),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _primaryColor),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _primaryColor),

      // Body styles - main content text
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: _primaryColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: _primaryColor),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: _primaryColor),

      // Label styles - buttons, labels, captions
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _primaryColor),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _primaryColor),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: _primaryColor),
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

    // Icon theme for consistent icon styling
    iconTheme: IconThemeData(color: _primaryColor, size: 30),

    // Text button theme
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

    // Divider theme for consistent divider styling
    dividerTheme: DividerThemeData(color: _primaryColor.withValues(alpha: 0.3), thickness: 1),

    // Input decoration theme for text fields
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
      labelStyle: TextStyle(fontSize: 20, color: _primaryColor.withValues(alpha: 0.3)),
      filled: true,
      fillColor: _primaryColor.withValues(alpha: 0.05),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
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
