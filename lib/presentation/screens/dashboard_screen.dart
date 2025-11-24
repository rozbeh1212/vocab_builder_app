import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/word_notifier.dart'; // Import the Riverpod notifier
import '../../core/providers/user_profile_notifier.dart'; // Import UserProfileNotifier
import '../../utils/app_router.dart'; // Import AppRouter

/// A screen that displays the main dashboard, including a list of all words
/// and a button to start a review session for due words.
/// This screen is a [ConsumerWidget] to interact with Riverpod providers.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    developer.log('[DashboardScreen] Build method called.');
    // Watch the wordNotifierProvider to get the state of the word list.
    // The UI will automatically rebuild when this state changes.
    final wordState = ref.watch(wordNotifierProvider);
    final userProfileAsync = ref.watch(userProfileNotifierProvider);
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
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Word',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.addWordRoute);
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (profile) {
          final reviewsCompleted = profile.reviewsCompletedToday;
          final dailyGoal = profile.dailyReviewGoal;
          final progress = dailyGoal > 0 ? reviewsCompleted / dailyGoal : 0.0;

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Streak: ${profile.currentStreak} 🔥',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Today's Goal: $reviewsCompleted / $dailyGoal reviews",
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: theme.colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: wordState.when(
                  data: (wordList) {
                    // Show a message if the list of words is empty.
                    if (wordList.isEmpty) {
                      return const Center(
                        child: Text('No words found. Add some words to get started.'),
                      );
                    }

                    // Filter the list to display only words due for review on the dashboard.
                    final dueForReviewWords =
                        wordList.where((word) => word.dueDate.isBefore(DateTime.now())).toList();

                    if (dueForReviewWords.isEmpty) {
                      return const Center(
                        child: Text('No words due for review. Check back later!'),
                      );
                    }

                    // Display the list of words using a ListView.builder.
                    return ListView.builder(
                      itemCount: dueForReviewWords.length,
                      itemBuilder: (context, index) {
                        final word = dueForReviewWords[index];
                        final formattedDate =
                            DateFormat.yMMMd('fa_IR').format(word.dueDate.toLocal());

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ListTile(
                            title: Text(word.word,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('مرور بعدی: $formattedDate'),
                            trailing: const Icon(
                              Icons.circle,
                              color: Colors.blueAccent, // Always blue since these are due
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
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }
}
