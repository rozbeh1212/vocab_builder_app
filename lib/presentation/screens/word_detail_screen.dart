import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/word_data.dart';
import '../../core/models/word_srs.dart';
import '../../core/providers/word_notifier.dart';
import '../../utils/date_formatter.dart';
import '../widgets/common/app_loader.dart';
import '../widgets/word/word_details_display.dart';

// Define a FutureProvider to fetch word details.
final wordDetailsProvider =
    FutureProvider.autoDispose.family<WordData?, String>((ref, word) {
  return ref.watch(wordNotifierProvider.notifier).getWordDetails(word);
});

class WordDetailScreen extends ConsumerWidget {
  final String word;

  const WordDetailScreen({super.key, required this.word});

  void _showReviewModal(BuildContext context, WordSRS wordSrs, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Consumer(
          builder: (context, ref, child) {
            final notifier = ref.read(wordNotifierProvider.notifier);
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How well did you remember this word?',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Review #${wordSrs.repetition + 1} · Next: ${wordSrs.dueDate.reviewDateDisplay}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ReviewButton(
                        color: Colors.red,
                        label: 'Again',
                        description: 'Needs practice',
                        onPressed: () async {
                          await notifier.updateWordAfterReview(wordSrs, 1);
                          Navigator.of(context).pop();
                        },
                      ),
                      _ReviewButton(
                        color: Colors.amber,
                        label: 'Good',
                        description: 'Remembered',
                        onPressed: () async {
                          await notifier.updateWordAfterReview(wordSrs, 3);
                          Navigator.of(context).pop();
                        },
                      ),
                      _ReviewButton(
                        color: Colors.green,
                        label: 'Easy',
                        description: 'Perfect recall',
                        onPressed: () async {
                          await notifier.updateWordAfterReview(wordSrs, 5);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordState = ref.watch(wordNotifierProvider);
    final srsWords = wordState.value ?? [];
    final wordSrs = srsWords.firstWhere(
      (s) => s.word.toLowerCase() == word.toLowerCase(),
      orElse: () => WordSRS(word: '', dueDate: DateTime(0)), // Dummy value
    );
    final isInSrs = wordSrs.word.isNotEmpty;

    // Watch the new FutureProvider.
    final wordDetailsAsync = ref.watch(wordDetailsProvider(word));

    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: wordDetailsAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLoader(),
              const SizedBox(height: 16),
              Text('Loading details for "$word"...',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        error: (error, stack) => const Center(
          child: Text(
            'Error loading details.\nPlease check your connection.',
            textAlign: TextAlign.center,
          ),
        ),
        data: (wordData) {
          if (wordData == null) {
            return const Center(
              child: Text(
                'Word details not found.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return Column(
            children: [
              Expanded(child: WordDetailsDisplay(wordData: wordData)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isInSrs || wordState.isLoading
                          ? null
                          : () async {
                              await ref
                                  .read(wordNotifierProvider.notifier)
                                  .addWord(word);
                            },
                      icon: wordState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.add),
                      label: Text(isInSrs ? 'In Your List' : 'Add to List'),
                    ),
                    if (isInSrs)
                      ElevatedButton(
                        onPressed: () => _showReviewModal(context, wordSrs, ref),
                        child: const Text('Review'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewButton extends StatelessWidget {
  final Color color;
  final String label;
  final String description;
  final VoidCallback onPressed;

  const _ReviewButton({
    required this.color,
    required this.label,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(80, 44),
              ),
              child: Text(label),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
