import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to get the current theme state and rebuild on change
    return Consumer<SettingsProvider>( // Use SettingsProvider here
      builder: (context, settingsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: settingsProvider.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  // Use listen: false when calling a method inside a callback
                  settingsProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light); // Use setThemeMode
                },
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}