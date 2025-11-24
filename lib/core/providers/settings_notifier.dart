import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple settings state holding theme mode
class SettingsState {
  final ThemeMode themeMode;
  const SettingsState({required this.themeMode});

  SettingsState copyWith({ThemeMode? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsState(themeMode: ThemeMode.dark);
  }

  void setThemeMode(ThemeMode mode) {
    // Enforce dark mode (as previous behavior) but allow storing requested mode
    state = state.copyWith(themeMode: ThemeMode.dark);
  }
}

final settingsNotifierProvider = NotifierProvider<SettingsNotifier, SettingsState>(() => SettingsNotifier());
