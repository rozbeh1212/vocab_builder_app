import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/providers/settings_notifier.dart';
import '../../core/providers/word_notifier.dart'; // Import WordNotifier
import '../../core/providers/user_profile_notifier.dart'; // Import UserProfileNotifier
import '../../core/services/notification_service.dart'; // Import NotificationService
// Import AppRouter

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _dailyRemindersEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0); // Default to 8 PM

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyRemindersEnabled = prefs.getBool('dailyRemindersEnabled') ?? false;
      final int? hour = prefs.getInt('reminderTimeHour');
      final int? minute = prefs.getInt('reminderTimeMinute');
      if (hour != null && minute != null) {
        _reminderTime = TimeOfDay(hour: hour, minute: minute);
      }
    });
  }

  Future<void> _toggleDailyReminders(bool newValue) async {
    setState(() {
      _dailyRemindersEnabled = newValue;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyRemindersEnabled', newValue);

    if (newValue) {
      // If enabling, schedule with current or default time
      await NotificationService().scheduleDailyReviewReminder(time: _reminderTime);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily reminders enabled!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // If disabling, cancel all notifications
      await NotificationService().cancelAllNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily reminders disabled.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('reminderTimeHour', picked.hour);
      await prefs.setInt('reminderTimeMinute', picked.minute);

      // Reschedule notification with new time
      await NotificationService().scheduleDailyReviewReminder(time: _reminderTime);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder time set to ${picked.format(context)}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showSetDailyGoalDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileNotifierProvider).value;
    int currentGoal = userProfile?.dailyReviewGoal ?? 10;
    int selectedGoal = currentGoal;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Set Daily Review Goal'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Goal: $selectedGoal reviews per day'),
                  Slider(
                    value: selectedGoal.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 9, // (50-5)/5 = 9 divisions for steps of 5
                    label: selectedGoal.round().toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        selectedGoal = newValue.round();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                ref.read(userProfileNotifierProvider.notifier).setDailyGoal(selectedGoal);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Daily goal set to $selectedGoal!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          SwitchListTile(
            title: const Text('Enable Daily Reminders'),
            subtitle: const Text('Get a notification to review words daily.'),
            secondary: const Icon(Icons.notifications_active_outlined),
            value: _dailyRemindersEnabled,
            onChanged: _toggleDailyReminders,
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Reminder Time'),
            subtitle: Text(_reminderTime.format(context)),
            enabled: _dailyRemindersEnabled,
            onTap: _dailyRemindersEnabled ? _pickReminderTime : null,
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
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Set Daily Goal'),
            subtitle: const Text('Set your target number of daily reviews.'),
            onTap: () => _showSetDailyGoalDialog(context, ref),
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
