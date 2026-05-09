import 'package:flutter/widgets.dart'; // Menggunakan widgets.dart
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  // Constructor konstan agar bisa dipanggil AppTextTheme()
  const AppTextTheme();

  // 🔥 Static getter agar kode lama 'AppTextTheme.ts' tetap jalan

  // Base style untuk menghindari pengulangan (DRY)
  static final TextStyle _baseInter = GoogleFonts.inter(
    height: 1.5,
    color: const Color(0xFF111928), // Default text color (grey900)
  );

  static final TextStyle _basePoppins = GoogleFonts.poppins(
    height: 1.5,
    color: const Color(0xFF111928),
  );

  // ===== HEADINGS =====
  static TextStyle headlineLarge = _baseInter.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headlineMedium = _baseInter.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headlineSmall = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleLarge = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  // ===== BODY =====
  static TextStyle bodyLarge = _baseInter.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyMedium = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodySmall = _baseInter.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // ===== BUTTON =====
  static TextStyle labelLarge = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // ===== XS (Poppins) =====
  static TextStyle labelMedium = _basePoppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = _basePoppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
