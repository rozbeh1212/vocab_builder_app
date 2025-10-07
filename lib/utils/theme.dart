import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [AppTheme] provides a centralized and consistent theming system for the application.
///
/// This class defines the color schemes, typography, and component styles
/// following Material 3 design principles to ensure a cohesive and modern UI.
class AppTheme {
  // --- Spacing and Radius Constants ---
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;

  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;

  /// Defines the dark theme for the application.
  static ThemeData get darkTheme {
    // A modern Material 3 dark color scheme.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF64B5F6), // A pleasant blue as the primary color
      brightness: Brightness.dark,
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
    );

    final textTheme = _buildTextTheme(GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD)),
        margin: const EdgeInsets.symmetric(
            horizontal: spacingMD, vertical: spacingSM),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: spacingMD, vertical: spacingSM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSM)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSM)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.12),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: TextStyle(color: colorScheme.surface),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Creates a refined [TextTheme] based on the provided base theme.
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.bold),
      displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.bold),
      displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.bold),
      headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}