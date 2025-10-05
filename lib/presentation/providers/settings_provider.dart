import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // Always return dark theme
  ThemeMode get themeMode => ThemeMode.dark;

  SettingsProvider();

  // No theme switching functionality needed
}