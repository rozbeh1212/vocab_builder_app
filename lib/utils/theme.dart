import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [AppTheme] provides consistent theming across the application.
///
/// This class manages:
/// * Color schemes
/// * Typography
/// * Spacing
/// * Component themes
///
/// Features:
/// * Dark mode optimization
/// * Material 3 support
/// * RTL compatibility
/// * Accessibility considerations
///
/// Usage:
/// ```dart
/// Theme(
///   data: AppTheme.darkTheme,
///   child: MyApp(),
/// )
/// ```
class AppTheme {
  // Spacing constants following Material Design guidelines
  /// Extra small spacing (4.0)
  static const double spacing_xs = 4.0;
  /// Small spacing (8.0)
  static const double spacing_sm = 8.0;
  /// Medium spacing (16.0)
  static const double spacing_md = 16.0;
  /// Large spacing (24.0)
  static const double spacing_lg = 24.0;
  /// Extra large spacing (32.0)
  static const double spacing_xl = 32.0;

  // Border radius constants
  static const double radius_sm = 4.0;
  static const double radius_md = 8.0;
  static const double radius_lg = 12.0;
  static const double radius_xl = 16.0;

  static ThemeData get darkTheme {
    const primary = Color(0xFF64B5F6); // Lighter blue for dark theme
    const primaryContainer = Color(0xFF1976D2);
    const surface = Color(0xFF121212);
    const background = Color(0xFF000000);
    const secondary = Color(0xFF4DD0E1);
    const error = Color(0xFFCF6679);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        surface: surface,
        background: background,
        error: error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
      ),
      typography: Typography.material2021(),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.5,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius_lg)),
        margin: EdgeInsets.all(spacing_sm),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing_md,
          vertical: spacing_sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius_md),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black12,
        thickness: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF323232),
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}