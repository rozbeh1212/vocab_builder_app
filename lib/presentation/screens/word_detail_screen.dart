import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/word_data.dart';
import '../../utils/date_formatter.dart';
import '../providers/word_provider.dart';
import '../widgets/word/word_details_display.dart';

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

class WordDetailScreen extends StatefulWidget {
  final String word;

  const WordDetailScreen({super.key, required this.word});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Do not auto-add to SRS on open. Details will be fetched when the FutureBuilder runs.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, child) {
          // Show details while allowing explicit add to SRS
          return FutureBuilder<WordData?>(
            future: provider.getWordDetails(widget.word),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text('Loading details for "${widget.word}"...', 
                        style: Theme.of(context).textTheme.titleMedium
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return const Center(
                  child: Text(
                    'Error loading details.\nPlease check your internet connection.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final inSrs = provider.words.any((s) => s.word.toLowerCase() == widget.word.toLowerCase());
              final wordData = snapshot.data!;

              return Column(
                children: [
                  Expanded(child: WordDetailsDisplay(wordData: wordData)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: inSrs
                              ? null
                              : () async {
                                  await provider.addWord(widget.word);
                                  if (provider.error != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error!)));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added "${widget.word}" to SRS')));
                                  }
                                  setState(() {});
                                },
                          icon: const Icon(Icons.add),
                          label: Text(inSrs ? 'In SRS' : 'Add to SRS'),
                        ),
                        if (inSrs)
                          ElevatedButton(
                            onPressed: () {
                              // Open review actions when in SRS
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  final wordSrs = provider.words.firstWhere((s) => s.word.toLowerCase() == widget.word.toLowerCase());
                                  return Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('How well did you remember this word?',
                                            style: Theme.of(context).textTheme.titleMedium),
                                        const SizedBox(height: 8),
                                        // Show SRS stats
                                        Text(
                                          'Review #${wordSrs.repetition + 1} · Next review ${wordSrs.dueDate.reviewDateDisplay}',
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
                                          description: 'Needs more practice',
                                          onPressed: () async {
                                            await provider.updateWordAfterReview(wordSrs, 1);
                                            if (mounted) Navigator.of(context).pop();
                                          },
                                        ),
                                        _ReviewButton(
                                          color: Colors.amber,
                                          label: 'Good',
                                          description: 'Remembered with effort',
                                          onPressed: () async {
                                            await provider.updateWordAfterReview(wordSrs, 3);
                                            if (mounted) Navigator.of(context).pop();
                                          },
                                        ),
                                        _ReviewButton(
                                          color: Colors.green,
                                          label: 'Easy',
                                          description: 'Perfect recall',
                                          onPressed: () async {
                                            await provider.updateWordAfterReview(wordSrs, 5);
                                            if (mounted) Navigator.of(context).pop();
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
                            child: const Text('Review'),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}