import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/word_notifier.dart'; // Import the Riverpod notifier
import '../../utils/app_router.dart'; // Import AppRouter

/// A screen that displays the main dashboard, including a list of all words
/// and a button to start a review session for due words.
/// This screen is a [ConsumerWidget] to interact with Riverpod providers.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the wordNotifierProvider to get the state of the word list.
    // The UI will automatically rebuild when this state changes.
    final wordState = ref.watch(wordNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // The review button is built using the wordState.when method,
          // which handles loading, data, and error states from the provider.
          wordState.when(
            data: (wordList) {
              // Filter the list to find words that are due for review.
              final dueForReviewWords =
                  wordList.where((word) => word.dueDate.isBefore(DateTime.now())).toList();
              final dueCount = dueForReviewWords.length;
              if (dueCount == 0) return const SizedBox.shrink();

              return TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.reviewRoute, // Use named route
                    arguments: dueForReviewWords,
                  );
                },
                icon: Text('${dueForReviewWords.length}'),
                label: const Text('مرور'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Word',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.addWordRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'View All Words',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.wordListRoute);
            },
          ),
        ],
      ),
      body: wordState.when(
        data: (wordList) {
          // Show a message if the list of words is empty.
          if (wordList.isEmpty) {
            return const Center(
              child: Text('No words found. Add some words to get started.'),
            );
          }

          // Display the list of words using a ListView.builder.
          return ListView.builder(
            itemCount: wordList.length,
            itemBuilder: (context, index) {
              final word = wordList[index];
              final isDue = word.dueDate.isBefore(DateTime.now());
              final formattedDate =
                  DateFormat.yMMMd('fa_IR').format(word.dueDate.toLocal());

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(word.word,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('مرور بعدی: $formattedDate'),
                  trailing: Icon(
                    Icons.circle,
                    color: isDue ? Colors.blueAccent : Colors.grey.shade700,
                    size: 12,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.wordDetailRoute,
                      arguments: word.word,
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.addWordRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
