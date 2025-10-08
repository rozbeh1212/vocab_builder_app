import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_notifier.dart';
import '../../core/providers/word_notifier.dart'; // Import WordNotifier
import '../../utils/app_router.dart'; // Import AppRouter

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the settings provider to get the current state.
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Currently, only dark mode is available.'),
            secondary: const Icon(Icons.dark_mode_outlined),
            // The value is always true as we are enforcing dark mode.
            value: settings.themeMode == ThemeMode.dark,
            // The onChanged callback is disabled because the theme is fixed.
            onChanged: null,
            // (bool value) {
            //   // This logic is preserved in case you want to re-enable theme switching.
            //   // As per the requirement, we are forcing dark mode.
            //   final newMode = value ? ThemeMode.dark : ThemeMode.light;
            //   settingsNotifier.setThemeMode(newMode);
            // },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Load IELTS Words'),
            subtitle: const Text('Add a predefined list of IELTS vocabulary.'),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Loading IELTS words...'),
                    ],
                  ),
                  duration: Duration(days: 1),
                ),
              );
              await ref.read(wordNotifierProvider.notifier).loadIeltsWords();
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('IELTS words loaded!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('Load TOEFL Words'),
            subtitle: const Text('Add a predefined list of TOEFL vocabulary.'),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Loading TOEFL words...'),
                    ],
                  ),
                  duration: Duration(days: 1),
                ),
              );
              await ref.read(wordNotifierProvider.notifier).loadToeflWords();
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('TOEFL words loaded!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('App version, licenses, and more.'),
            onTap: () {
              // Show the about dialog with application details.
              showAboutDialog(
                context: context,
                applicationName: 'Vocab Builder',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Rozbeh',
                children: [
                  const SizedBox(height: 16),
                  const Text('This app helps you build and review your vocabulary using spaced repetition.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
