import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Defines the state for settings, currently only holding the [ThemeMode].
@immutable
class SettingsState {
  final ThemeMode themeMode;

  const SettingsState({this.themeMode = ThemeMode.dark});

  SettingsState copyWith({ThemeMode? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
  }
}

/// A Notifier for managing application settings.
///
/// This provider handles the state of user-configurable settings, such as the
/// theme mode. It is designed to replace older state management patterns like ChangeNotifier.
class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    // The initial state is set to dark mode.
    // In a real-world scenario, you might load this from SharedPreferences.
    return const SettingsState(themeMode: ThemeMode.dark);
  }

  /// Sets the application's theme mode.
  ///
  /// Note: The current implementation enforces dark mode as per the original logic.
  /// To enable theme switching, you would change `ThemeMode.dark` to `mode`.
  void setThemeMode(ThemeMode mode) {
    // The original logic strictly enforced dark mode. This behavior is maintained.
    // To enable theme switching, change the line to: state = state.copyWith(themeMode: mode);
    state = state.copyWith(themeMode: ThemeMode.dark);
  }
}

/// The provider that exposes the [SettingsNotifier] to the widget tree.
final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);