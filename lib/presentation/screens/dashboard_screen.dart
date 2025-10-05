import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/word_provider.dart';
 // Import WordListScreen
import '../../utils/app_router.dart'; // Import AppRouter

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // The review button code remains here...
          Consumer<WordProvider>(
            builder: (context, provider, child) {
              final dueCount = provider.dueForReviewWords.length;
              if (dueCount == 0) return const SizedBox.shrink();

              return TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.reviewRoute, // Use named route
                    arguments: provider.dueForReviewWords,
                  );
                },
                icon: Text('$dueCount'),
                label: const Text('مرور'),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              );
            },
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
      body: Consumer<WordProvider>(
        builder: (context, provider, child) {
          // Show a loading spinner only on initial load
          if (provider.isLoading && provider.words.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show a message if the list of words is empty
          if (provider.words.isEmpty) {
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
            itemCount: provider.words.length,
            itemBuilder: (context, index) {
              final word = provider.words[index];
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