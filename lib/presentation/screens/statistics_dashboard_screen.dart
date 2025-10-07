import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/word_srs.dart';
import '../../core/providers/word_notifier.dart';
import '../../utils/date_formatter.dart';

class StatisticsDashboardScreen extends ConsumerWidget {
  const StatisticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordState = ref.watch(wordNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export progress',
            onPressed: () {
              // TODO: Implement export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export coming soon')),
              );
            },
          ),
        ],
      ),
      body: wordState.when(
        data: (words) {
          final dueNow = words.where((w) => w.dueDate.isBefore(DateTime.now())).toList();
          
          // Calculate statistics
          final totalWords = words.length;
          final masterCount = words.where((w) => w.interval >= 30).length;
          final learningCount = words.where((w) => w.interval > 0 && w.interval < 30).length;
          final newCount = words.where((w) => w.interval == 0).length;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatsCard(context, words, dueNow),
              const SizedBox(height: 16),
              _buildProgressCard(context, masterCount, learningCount, newCount, totalWords),
              const SizedBox(height: 16),
              if (dueNow.isNotEmpty) _buildDueWordsCard(context, dueNow),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, List<WordSRS> words, List<WordSRS> dueNow) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(context, 'Total Words', '${words.length}'),
                _buildStat(context, 'Due for Review', '${dueNow.length}'),
                _buildStat(
                  context, 
                  'Review Success',
                  words.isEmpty ? '0%' : 
                    '${((words.map((w) => w.efactor).reduce((a, b) => a + b) / words.length - 2.5) * 200).toStringAsFixed(0)}%'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, int master, int learning, int new_, int total) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learning Progress', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : (master + learning) / total,
                backgroundColor: Colors.grey[200],
                minHeight: 24,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(context, 'Mastered', '$master', color: Colors.green),
                _buildStat(context, 'Learning', '$learning', color: Colors.amber),
                _buildStat(context, 'New', '$new_', color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueWordsCard(BuildContext context, List<WordSRS> dueWords) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due for Review', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dueWords.length.clamp(0, 5),
              itemBuilder: (context, index) {
                final word = dueWords[index];
                return ListTile(
                  title: Text(word.word),
                  subtitle: Text(word.dueDate.reviewDateDisplay),
                  trailing: Text(
                    'Review #${word.repetition + 1}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
            if (dueWords.length > 5) ...[
              const Divider(),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to full review list
                  },
                  child: Text('${dueWords.length - 5} more words due'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
