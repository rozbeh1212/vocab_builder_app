import 'dart:developer' as developer; // Import for logging
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word_data.dart';
import '../models/word_srs.dart';
import '../services/cache_service.dart';
import '../services/default_word_service.dart'; // Import DefaultWordService
import '../services/gemini_service.dart';
import '../services/srs_service.dart';

/// Provides an asynchronous notifier for managing the list of [WordSRS] objects.
///
/// This provider handles loading words from the cache, adding new words by fetching
/// details from an external service, and updating words after a review session.
final wordNotifierProvider =
    AsyncNotifierProvider<WordNotifier, List<WordSRS>>(WordNotifier.new);

class WordNotifier extends AsyncNotifier<List<WordSRS>> {
  final CacheService _cacheService = CacheService.instance;
  final GeminiService _geminiService = GeminiService();
  final DefaultWordService _defaultWordService = DefaultWordService(); // Instantiate DefaultWordService

  /// The build method is called when the provider is first read.
  /// It initializes the state by loading all SRS words from the local cache.
  @override
  Future<List<WordSRS>> build() async {
    return _cacheService.getAllWordSRS();
  }

  /// Helper method to add a list of words, handling duplicates and fetching details.
  Future<void> _addWordsFromList(List<String> words) async {
    state = const AsyncValue.loading(); // Set state to loading for the batch operation
    try {
      List<WordSRS> currentWords = state.value ?? [];
      final List<WordSRS> wordsToAdd = [];

      for (final word in words) {
        final normalizedWord = word.trim().toLowerCase();
        if (normalizedWord.isEmpty) continue;

        // Check if word already exists
        if (currentWords.any((w) => w.word.toLowerCase() == normalizedWord) ||
            wordsToAdd.any((w) => w.word.toLowerCase() == normalizedWord)) {
          continue; // Skip if already exists or already in the current batch to add
        }

        WordData? wordData = await getWordDetails(normalizedWord);
        if (wordData != null) {
          final newSrsData = WordSRS(
            word: wordData.word,
            dueDate: DateTime.now(),
            repetition: 0,
            interval: 0,
            efactor: 2.5,
          );
          wordsToAdd.add(newSrsData);
        } else {
          // If word details cannot be fetched from GeminiService (e.g., API error, malformed response),
          // add the word with minimal SRS data. This ensures the word still appears in the UI
          // even if rich details are unavailable, preventing the display from breaking.
          developer.log('Failed to fetch details for word: $normalizedWord. Adding with minimal data.', name: 'WordNotifier');
          final newSrsData = WordSRS(
            word: normalizedWord,
            dueDate: DateTime.now(),
            repetition: 0,
            interval: 0,
            efactor: 2.5,
          );
          wordsToAdd.add(newSrsData);
        }
      }

      if (wordsToAdd.isNotEmpty) {
        await Future.wait(wordsToAdd.map((w) => _cacheService.saveWordSRS(w)));
        state = AsyncValue.data([...currentWords, ...wordsToAdd]);
      } else {
        state = AsyncValue.data(currentWords); // Restore previous state if no new words were added
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Loads IELTS words from the asset file and adds them to the vocabulary.
  Future<void> loadIeltsWords() async {
    final ieltsWords = await _defaultWordService.loadWordsFromAsset('assets/data/ielts_words.json');
    await _addWordsFromList(ieltsWords);
  }

  /// Loads TOEFL words from the asset file and adds them to the vocabulary.
  Future<void> loadToeflWords() async {
    final toeflWords = await _defaultWordService.loadWordsFromAsset('assets/data/toefl_words.json');
    await _addWordsFromList(toeflWords);
  }

  /// Adds a new word to the user's vocabulary list.
  ///
  /// It first checks if the word already exists. If not, it fetches word details
  /// from the Gemini service, caches them, creates a new SRS entry, and updates the state.
  Future<void> addWord(String newWord) async {
    final normalizedWord = newWord.trim().toLowerCase();
    if (normalizedWord.isEmpty) return;

    // For single word addition, we can reuse the existing logic
    // but ensure it doesn't interfere with batch loading state.
    final previousState = state;
    state = const AsyncValue.loading();

    try {
      final normalizedWord = newWord.trim().toLowerCase();
      if (normalizedWord.isEmpty) {
        state = previousState; // Restore state if input is empty
        return;
      }

      final existingWords = previousState.value ?? [];
      if (existingWords.any((w) => w.word.toLowerCase() == normalizedWord)) {
        state = previousState; // Restore previous data state if word already exists
        return;
      }

      WordData? wordData = await getWordDetails(normalizedWord);

      if (wordData != null) {
        final newSrsData = WordSRS(
          word: wordData.word,
          dueDate: DateTime.now(),
          repetition: 0,
          interval: 0,
          efactor: 2.5,
        );

        await _cacheService.saveWordSRS(newSrsData);
        state = AsyncValue.data([...existingWords, newSrsData]);
      } else {
        // If word details cannot be fetched for a single word addition,
        // add the word with minimal SRS data. This ensures the word still appears
        // in the UI even if rich details are unavailable.
        developer.log('Failed to fetch details for word: $normalizedWord. Adding with minimal data.', name: 'WordNotifier');
        final newSrsData = WordSRS(
          word: normalizedWord,
          dueDate: DateTime.now(),
          repetition: 0,
          interval: 0,
          efactor: 2.5,
        );
        await _cacheService.saveWordSRS(newSrsData);
        state = AsyncValue.data([...existingWords, newSrsData]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Updates a word's SRS data after a user review.
  ///
  /// [word]: The [WordSRS] object to be updated.
  /// [quality]: An integer (0-5) representing the user's recall quality.
  Future<void> updateWordAfterReview(WordSRS word, int quality) async {
    final currentWords = state.valueOrNull;
    if (currentWords == null) return; // Cannot update if state is not loaded

    try {
      // 1. Calculate the new SRS parameters using the SM2 algorithm.
      final updatedWord = SRSService.sm2(word, quality);

      // 2. Save the updated data to the cache.
      await _cacheService.saveWordSRS(updatedWord);

      // 3. Update the state in memory for immediate UI feedback.
      final index = currentWords.indexWhere((w) => w.word == updatedWord.word);
      if (index != -1) {
        final updatedList = List<WordSRS>.from(currentWords);
        updatedList[index] = updatedWord;
        state = AsyncValue.data(updatedList);
      }
    } catch (e, st) {
      // If update fails, set the state to error.
      state = AsyncValue.error(e, st);
    }
  }

  /// Retrieves details for a given word.
  ///
  /// It first attempts to load from the local cache. If not found, it fetches
  /// from the [GeminiService] and caches the result for future use.
  Future<WordData?> getWordDetails(String word) async {
    try {
      // First, try to get details from the cache.
      WordData? details = await _cacheService.getWordDetails(word);
      if (details != null) {
        return details;
      }

      // If not in cache, fetch from the external service.
      details = await _geminiService.getWordDetails(word);
      if (details != null) {
        // If fetched successfully, save to cache for next time.
        await _cacheService.saveWordDetails(word, details);
      }
      return details;
    } catch (e) {
      // In case of error, return null. The caller should handle this.
      return null;
    }
  }
}
