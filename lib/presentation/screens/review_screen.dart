import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/word_srs.dart';
import '../../core/models/word_data.dart';
import '../../core/providers/word_notifier.dart';
import '../../core/providers/user_profile_notifier.dart'; // Import the user profile notifier
import '../widgets/common/app_loader.dart';
import '../widgets/review/flashcard_widget.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final List<WordSRS> wordsToReview;
  const ReviewScreen({super.key, required this.wordsToReview});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _currentIndex = 0;
  bool _isUpdating = false;

  Future<void> _handleQualitySelected(int quality) async {
    if (_isUpdating) return; // Prevent multiple taps while processing

    setState(() {
      _isUpdating = true;
    });

    final wordNotifier = ref.read(wordNotifierProvider.notifier);
    await wordNotifier.updateWordAfterReview(
        widget.wordsToReview[_currentIndex], quality);

    // Record review completion for daily goals
    await ref.read(userProfileNotifierProvider.notifier).recordReviewCompletion();

    // Check if there are more words to review
    if (_currentIndex < widget.wordsToReview.length - 1) {
      // Move to the next word
      setState(() {
        _currentIndex++;
        _isUpdating = false;
      });
    } else {
      // Last word has been reviewed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جلسه مرور تمام شد!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle the case where the list might be empty
    if (widget.wordsToReview.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Session')),
        body: const Center(
          child: Text('No words to review.'),
        ),
      );
    }
    
    final currentWordSRS = widget.wordsToReview[_currentIndex];
    final wordNotifier = ref.read(wordNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Review Session (${_currentIndex + 1}/${widget.wordsToReview.length})'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<WordData?>(
              future: wordNotifier.getWordDetails(currentWordSRS.word),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: AppLoader());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                      child: Text('Error loading word details.'));
                }
                // Use a Key to ensure the widget rebuilds when the word changes
                return FlashcardWidget(
                  key: ValueKey(currentWordSRS.word),
                  wordData: snapshot.data!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildQualityButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _qualityButton('Hard', 1, Colors.red),
        _qualityButton('Good', 3, Colors.amber),
        _qualityButton('Easy', 5, Colors.green),
      ],
    );
  }

  Widget _qualityButton(String label, int quality, Color color) {
    return ElevatedButton(
      onPressed: _isUpdating ? null : () => _handleQualitySelected(quality),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(label),
    );
  }
}
