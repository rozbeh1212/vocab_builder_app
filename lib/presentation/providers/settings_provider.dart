import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  SettingsProvider();

  // Since we're enforcing dark mode, this will always set to dark
  void setThemeMode(ThemeMode mode) {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }
}