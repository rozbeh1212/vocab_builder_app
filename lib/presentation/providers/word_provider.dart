import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/word_srs.dart';
import '../../core/providers/word_notifier.dart';

// --- DEPRECATION NOTE ---
// This file appears to contain a legacy state management implementation using ChangeNotifier.
// The project has been migrated to use Riverpod with `word_notifier.dart` for managing
// the state of vocabulary words.
//
// The providers below are created to ensure compatibility with any remaining widgets
// that might still be depending on the old provider, but they now derive their state
// directly from the new `wordNotifierProvider`.
//
// It is highly recommended to refactor any remaining usages of `wordProvider`
// to use `wordNotifierProvider` directly and then remove this file entirely.

/// A provider that exposes the list of [WordSRS] words from the main [wordNotifierProvider].
///
/// This is a compatibility layer. Widgets should be updated to watch `wordNotifierProvider` instead.
final wordListProvider = Provider<List<WordSRS>>((ref) {
  // Derives its state from the primary notifier, returning the data or an empty list.
  return ref.watch(wordNotifierProvider).valueOrNull ?? [];
});

/// A provider that exposes the loading state from the main [wordNotifierProvider].
final wordIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(wordNotifierProvider).isLoading;
});

/// A provider that exposes any error state from the main [wordNotifierProvider].
final wordErrorProvider = Provider<Object?>((ref) {
  return ref.watch(wordNotifierProvider).error;
});

/// A provider that calculates and exposes the list of words currently due for review.
final dueForReviewWordsProvider = Provider<List<WordSRS>>((ref) {
  // Watch the main notifier to get the list of all words.
  final words = ref.watch(wordNotifierProvider).valueOrNull ?? [];
  
  // Filter the list to find words that are due.
  final now = DateTime.now();
  final dueWords = words.where((word) => !word.dueDate.isAfter(now)).toList();
  
  // Sort the due words by their due date to review the oldest ones first.
  dueWords.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  
  return dueWords;
});