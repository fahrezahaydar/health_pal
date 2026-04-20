import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_text_theme.dart';

class AppTheme {
  // === MAIN ===
  static Color primary = Color(0xff1C2A3A);
  static Color onPrimary = Colors.white;
  static const Color white = Color(0xFFFFFFFF);

  // === GREYSCALE ===
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2A37);
  static const Color grey900 = Color(0xFF111928);

  // === OTHERS ===
  static const Color deepTeal = Color(0xFF014737);
  static const Color teal = Color(0xFF4D9B91);
  static const Color lightTeal = Color(0xFFA4CFC3);
  static const Color green = Color(0xFF93C19E);
  static const Color paleGreen = Color(0xFFDEF7E4);

  static const Color darkRed = Color(0xFF7F1D1D);
  static const Color deepPink = Color(0xFFDC9497);
  static const Color pink = Color(0xFFD6B6B5);
  static const Color lightPink = Color(0xFFFDE8E8);
  static const Color lightPurple = Color(0xFFA1A1C9);

  static const Color blue = Color(0xFF1C64F2);
  static const Color paleBlue = Color(0xFF89CCDB);
  static const Color purple = Color(0xFF352261);
  static const Color orange = Color(0xFFF5AD7E);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xff1C2A3A),
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        minimumSize: Size.fromHeight(48),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: Size.fromHeight(48)),
    ),
    textTheme: AppTextTheme.textTheme,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xff1C2A3A),
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: Colors.black,

    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),

    
    textTheme: AppTextTheme.textTheme,

  );
}
