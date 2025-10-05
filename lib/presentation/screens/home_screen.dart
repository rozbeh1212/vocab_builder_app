import 'package:flutter/material.dart';
import 'package:vocab_builder_app/utils/app_router.dart';
import 'word_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _categoryCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Choose a list to start practicing', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _categoryCard(
              context,
              'IELTS Words',
              'High-frequency academic words for IELTS',
              Icons.school,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordListScreen(category: 'IELTS'))),
            ),
            _categoryCard(
              context,
              'TOEFL Words',
              'Useful vocabulary for academic reading and listening',
              Icons.book,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordListScreen(category: 'TOEFL'))),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRouter.dashboardRoute),
              icon: const Icon(Icons.dashboard),
              label: const Text('Open My Vocabulary Dashboard'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.statisticsRoute),
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('Statistics'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.settingsRoute),
                    icon: const Icon(Icons.settings),
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