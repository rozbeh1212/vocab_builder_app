import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart'; // Import the package

import '../../core/models/word_srs.dart';
import '../../core/models/word_data.dart';
import '../providers/word_provider.dart';
import '../widgets/word/word_details_display.dart';

class ReviewScreen extends StatefulWidget {
  final List<WordSRS> wordsToReview;
  const ReviewScreen({super.key, required this.wordsToReview});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentIndex = 0;
  bool _isUpdating = false;
  // We no longer need the _isFlipped variable!
  // The FlipCard widget will manage its own state.
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();


  Future<void> _handleQualitySelected(int quality) async {
    if (_isUpdating) return; // prevent double clicks
    setState(() {
      _isUpdating = true;
    });

  final provider = Provider.of<WordProvider>(context, listen: false);
  // Capture navigator and messenger before the async call to avoid
  // using BuildContext across async gaps.
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  await provider.updateWordAfterReview(widget.wordsToReview[_currentIndex], quality);

    if (_currentIndex < widget.wordsToReview.length - 1) {
      setState(() {
        _currentIndex++;
        _isUpdating = false;
      });
      // Flip back to front for the next item (if card is showing back)
      cardKey.currentState?.toggleCard();
    } else {
      setState(() {
        _isUpdating = false;
      });
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('جلسه مرور تمام شد!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWordSRS = widget.wordsToReview[_currentIndex];
    final wordProvider = Provider.of<WordProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Session (${_currentIndex + 1}/${widget.wordsToReview.length})'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // Replace GestureDetector and Card with FlipCard
            child: FlipCard(
              key: cardKey,
              flipOnTouch: true, // Card flips on tap
              front: Card( // The front of the card
                margin: const EdgeInsets.all(16),
                child: Center(
                  child: Text(currentWordSRS.word, style: Theme.of(context).textTheme.headlineLarge),
                ),
              ),
              back: Card( // The back of the card
                margin: const EdgeInsets.all(16),
                child: FutureBuilder<WordData?>(
                  future: wordProvider.getWordDetails(currentWordSRS.word),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Center(child: Text('Error loading details.'));
                    }
                    return WordDetailsDisplay(wordData: snapshot.data!);
                  },
                ),
              ),
            ),
          ),
          // We need to know the card's state to show the buttons
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
        _qualityButton('سخت بود', 1, Colors.red),
        _qualityButton('خوب بود', 3, Colors.amber),
        _qualityButton('آسان بود', 5, Colors.green),
      ],
    );
  }

  Widget _qualityButton(String label, int quality, Color color) {
    return ElevatedButton(
      onPressed: _isUpdating ? null : () => _handleQualitySelected(quality),
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
      child: Text(label),
    );
  }
}