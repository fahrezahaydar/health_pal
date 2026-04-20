import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme textTheme = TextTheme(
    // ===== HEADINGS =====
    headlineLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),

    // ===== BODY =====
    bodyLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),

    // ===== BUTTON =====
    labelLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),

    // ===== XS (Poppins) =====
    labelMedium: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
  );
}
