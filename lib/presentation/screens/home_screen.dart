import 'package:flutter/material.dart';
import '../../utils/app_router.dart';
import 'word_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// A reusable widget for creating tappable category cards.
  Widget _categoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Icon(icon, color: theme.colorScheme.onPrimary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose a list to start practicing',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _categoryCard(
              context,
              title: 'IELTS Words',
              subtitle: 'High-frequency academic words for IELTS',
              icon: Icons.school_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WordListScreen(category: 'ielts'),
                ),
              ),
            ),
            _categoryCard(
              context,
              title: 'TOEFL Words',
              subtitle: 'Essential vocabulary for the TOEFL test',
              icon: Icons.book_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WordListScreen(category: 'toefl'),
                ),
              ),
            ),
            const Spacer(), // Pushes content to the bottom
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRouter.dashboardRoute),
              icon: const Icon(Icons.dashboard_outlined),
              label: const Text('Open My Vocabulary Dashboard'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.statisticsRoute),
                    icon: const Icon(Icons.bar_chart_outlined),
                    label: const Text('Statistics'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.settingsRoute),
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Settings'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}