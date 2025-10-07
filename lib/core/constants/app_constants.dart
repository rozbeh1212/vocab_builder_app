import 'package:flutter/material.dart';

/// [AppConstants] provides a centralized place for constant values used
/// throughout the application, such as colors, spacing, and border radius.
///
/// Using a constants class like this helps in maintaining a consistent
/// design system and makes it easier to update global values.
class AppConstants {
  // This class is not meant to be instantiated.
  AppConstants._();

  // --- Colors ---
  // It's often better to define colors within the theme, but for universal
  // constants that might be used outside of the theme context, this is a
  // suitable place.
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.lightBlueAccent;
  static const Color textColor = Colors.black87;

  // --- Spacing ---
  // Consistent spacing values help in creating a balanced and harmonious layout.
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // --- Border Radius ---
  // Using predefined border radius values ensures that UI elements have a
  // consistent look and feel.
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
}