import 'package:flutter/material.dart';

class AppTextTheme {
  // Constructor konstan agar bisa dipanggil AppTextTheme()
  const AppTextTheme();

  static TextTheme get textTheme => TextTheme(
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  // 🔥 Static getter agar kode lama 'AppTextTheme.ts' tetap jalan

  // Base style untuk menghindari pengulangan (DRY)
  static const TextStyle _baseInter = TextStyle(fontFamily: 'Inter', height: 1.5);
  static const TextStyle inter = TextStyle(fontFamily: 'Inter', height: 1.5);

  static const TextStyle _basePoppins = TextStyle(fontFamily: 'Poppins', height: 1.5);

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
    fontSize: 14,
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
