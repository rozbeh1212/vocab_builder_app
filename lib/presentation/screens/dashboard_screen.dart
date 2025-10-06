import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/word_notifier.dart'; // Import the Riverpod notifier
 // Import WordListScreen
import '../../utils/app_router.dart'; // Import AppRouter

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordState = ref.watch(wordNotifierProvider);
    final words = wordState.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // The review button code remains here...
          wordState.when(
            data: (wordList) {
              final dueForReviewWords = wordList.where((word) => word.dueDate.isBefore(DateTime.now())).toList();
              final dueCount = dueForReviewWords.length;
              if (dueCount == 0) return const SizedBox.shrink();

              return TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.reviewRoute, // Use named route
                    arguments: dueForReviewWords,
                  );
                },
                icon: Text('$dueCount'),
                label: const Text('مرور'),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              );
            },
            loading: () => const SizedBox.shrink(), // Or a loading indicator
            error: (e, st) => const SizedBox.shrink(), // Or an error indicator
          ),
          // Add this IconButton for settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settingsRoute); // Use named route
            },
          ),
          // Add this IconButton for word list
          // IconButton(
          //   icon: const Icon(Icons.list),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(AppRouter.wordListRoute); // Use named route
          //   },
          // ),
        ],
      ),
      body: wordState.when(
        data: (wordList) {
          // Show a message if the list of words is empty
          if (wordList.isEmpty) {
            return const Center(
              child: Text(
                'هنوز کلمه‌ای اضافه نکرده‌اید.\nبرای شروع، روی دکمه + کلیک کنید.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Display the list of words
          return ListView.builder(
            itemCount: wordList.length,
            itemBuilder: (context, index) {
              final word = wordList[index];
              final isDue = word.dueDate.isBefore(DateTime.now());

              return ListTile(
                title: Text(word.word, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('مرور بعدی: ${DateFormat.yMMMd('fa_IR').format(word.dueDate.toLocal())}'),
                trailing: Icon(
                  Icons.circle,
                  color: isDue ? Colors.blue : Colors.grey.shade300,
                  size: 12,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.wordDetailRoute,
                    arguments: word.word,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.addWordRoute); // Use named route
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}