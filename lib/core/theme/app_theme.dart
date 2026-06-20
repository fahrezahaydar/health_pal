import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_text_theme.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.4.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // === MAIN ===
  static const Color primary = Color(0xff1C2A3A);
  static const Color onPrimary = Color(0xFFFFFFFF);
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
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF1C2A3A),
      primaryContainer: Color(0xFFD0E4FF),
      secondary: Color(0xFFAC3306),
      secondaryContainer: Color(0xFFFFDBCF),
      tertiary: Color(0xFF006875),
      tertiaryContainer: Color(0xFF95F0FF),
      appBarColor: Color(0xFFFFDBCF),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
    ),
    // Input color modifiers.
    usedColors: 1,
    useMaterial3ErrorColors: true,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabSchemeColor: SchemeColor.onPrimary,
      alignedDropdown: true,
      bottomNavigationBarShowSelectedLabels: false,
      bottomNavigationBarShowUnselectedLabels: false,
      searchBarRadius: 8.0,
      searchViewRadius: 8.0,
      navigationBarIndicatorSchemeColor: SchemeColor.surfaceContainerHighest,
      navigationBarIndicatorRadius: 25.0,
      navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    textTheme: AppTextTheme.textTheme,
    primaryTextTheme: AppTextTheme.textTheme,
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFFA4CFC3),
      primaryContainer: Color(0xFF00325B),
      primaryLightRef: Color(0xFF1C2A3A), // The color of light mode primary
      secondary: Color(0xFFFFB59D),
      secondaryContainer: Color(0xFF872100),
      secondaryLightRef: Color(0xFFAC3306), // The color of light mode secondary
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF004E59),
      tertiaryLightRef: Color(0xFF006875), // The color of light mode tertiary
      appBarColor: Color(0xFFFFDBCF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
    ),
    // Input color modifiers.
    usedColors: 1,
    useMaterial3ErrorColors: true,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabSchemeColor: SchemeColor.onPrimary,
      alignedDropdown: true,
      bottomNavigationBarShowSelectedLabels: false,
      bottomNavigationBarShowUnselectedLabels: false,
      searchBarRadius: 8.0,
      searchViewRadius: 8.0,
      navigationBarIndicatorSchemeColor: SchemeColor.surfaceContainerHighest,
      navigationBarIndicatorRadius: 25.0,
      navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    textTheme: AppTextTheme.textTheme,
    primaryTextTheme: AppTextTheme.textTheme,
  );
}
