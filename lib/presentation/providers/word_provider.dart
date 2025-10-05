import 'package:flutter/material.dart';
import '../../core/models/word_srs.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/srs_service.dart';
import '../../core/models/word_data.dart';
import 'dart:developer' as developer;

class WordProvider with ChangeNotifier {
  final CacheService _cacheService = CacheService.instance;
  final GeminiService _geminiService = GeminiService();

  List<WordSRS> _words = [];
  bool _isLoading = false;
  String? _error;

  List<WordSRS> get words => _words;
  bool get isLoading => _isLoading;
  String? get error => _error;

  WordProvider() {
    loadWords();
  }

  /// Loads all words from the local cache at startup.
  Future<void> loadWords() async {
    _setLoading(true);
    _words = await _cacheService.getAllWordSRS();
    _setLoading(false);
  }

  /// Get all words that are due for review, sorted by due date
  List<WordSRS> get dueForReviewWords {
    final now = DateTime.now();
    final due = _words.where((word) => !word.dueDate.isAfter(now)).toList();
    due.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return due;
  }

  /// Adds a new word, fetches its details, and saves it.
  Future<void> addWord(String newWord) async {
    _setLoading(true);
    _error = null;

    // Check if word already exists in SRS
    final existingSrs = await _cacheService.getWordSRS(newWord);
    if (existingSrs != null) {
      _error = 'این کلمه از قبل وجود دارد.';
      _setLoading(false);
      return;
    }

    // Try to get cached details first
    WordData? wordData = await _cacheService.getWordDetails(newWord);

    try {
      // If no cached details, fetch from API
      if (wordData == null) {
        developer.log('Fetching details for word: $newWord');
        wordData = await _geminiService.getWordDetails(newWord);
      }

      if (wordData != null) {
        // Save details to details_box (if not already saved)
        await _cacheService.saveWordDetails(newWord, wordData);

        // Create and save SRS data to srs_box
        final newSrsData = WordSRS(
          word: newWord,
          dueDate: DateTime.now(),
          repetition: 0,
          interval: 0,
          efactor: 2.5,
        );

        await _cacheService.saveWordSRS(newSrsData);

        // Update local list and notify UI
        _words.add(newSrsData);
        notifyListeners();
        developer.log('Word added successfully: $newWord');
      } else {
        _error = 'اطلاعاتی برای این کلمه یافت نشد.';
        developer.log('Failed to get details for word: $newWord');
      }
    } catch (e) {
      _error = 'خطایی در ارتباط با سرویس رخ داد.';
      developer.log('Error adding word: $newWord', error: e);
    } finally {
      _setLoading(false);
    }
  }

  /// Retrieves word details from cache or fetches them if needed
  Future<WordData?> getWordDetails(String word) async {
    try {
      // First try to get from cache
      WordData? details = await _cacheService.getWordDetails(word);
      if (details != null) {
        return details;
      }
      
      // If not in cache, fetch from Gemini
      developer.log('Fetching details for word: $word');
      details = await _geminiService.getWordDetails(word);
      if (details != null) {
        await _cacheService.saveWordDetails(word, details);
      }
      return details;
    } catch (e) {
      developer.log('Error getting word details: $word', error: e);
      return null;
    }
  }

  /// Updates a word's SRS data after a review
  Future<void> updateWordAfterReview(WordSRS word, int quality) async {
    try {
      developer.log('Updating SRS for word: ${word.word} with quality: $quality');
      
      // Calculate new SRS data using the service
      final updatedWord = SRSService.sm2(word, quality);
      
      // Save the updated word to the cache
      await _cacheService.saveWordSRS(updatedWord);
      
      // Update the list in memory
      final index = _words.indexWhere((element) => element.word == updatedWord.word);
      if (index != -1) {
        _words[index] = updatedWord;
        notifyListeners();
        developer.log('SRS updated for word: ${word.word}');
      }
    } catch (e) {
      developer.log('Error updating SRS for word: ${word.word}', error: e);
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}