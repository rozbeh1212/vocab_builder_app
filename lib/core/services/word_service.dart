import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vocab_builder_app/core/models/word.dart';

/// [WordService] manages loading predefined word lists from JSON assets.
///
/// This service is responsible for:
/// - Loading word lists for categories like IELTS and TOEFL from the app's assets.
/// - Loading default words from predefined-words.json when category files are not available.
/// - Parsing the JSON data into a list of [Word] objects.
/// - Handling potential errors during asset loading and parsing.
class WordService {
  /// Loads a list of words for a given [category] from a JSON asset file.
  ///
  /// The method first tries to load category-specific files from `assets/data/{category}_words.json`.
  /// If that fails, it falls back to the default `src/assets/predefined-words.json`.
  ///
  /// Returns a `Future<List<Word>>`. If all assets fail to load or parse,
  /// it logs the error and returns an empty list to prevent crashes.
  Future<List<Word>> loadWords(String category) async {
  // First try to load category-specific words (use full assets path)
  final String categoryAssetPath = 'assets/data/${category.toLowerCase()}_words.json';

    try {
      // Load the category-specific JSON file as a string from the root bundle.
      final String jsonString = await rootBundle.loadString(categoryAssetPath);
      developer.log('Successfully loaded words from asset: $categoryAssetPath');

      // Decode the JSON string into a list of dynamic objects.
      final List<dynamic> data = json.decode(jsonString);

      // Map the list of strings to a list of Word objects.
      // Since these are just word lists, meaning and example are null.
      return data
          .map((word) => Word(word: word.toString()))
          .toList();
    } catch (e, st) {
      // Log the error for category-specific file
      developer.log(
        'Failed to load category-specific words from asset: $categoryAssetPath, trying default words',
        error: e,
        stackTrace: st,
      );

      // Fall back to default words if category-specific file fails
      return _loadDefaultWords();
    }
  }

  /// Loads the default word list from predefined-words.json
  Future<List<Word>> _loadDefaultWords() async {
  const String defaultAssetPath = 'assets/data/default_words.json';

    try {
      // Load the default JSON file as a string from the root bundle.
      final String jsonString = await rootBundle.loadString(defaultAssetPath);
      developer.log('Successfully loaded default words from asset: $defaultAssetPath');

      // Decode the JSON string into a list of dynamic objects.
      final List<dynamic> data = json.decode(jsonString);

      // Map the list of strings to a list of Word objects.
      // Since these are just word lists, meaning and example are null.
      return data
          .map((word) => Word(word: word.toString()))
          .toList();
    } catch (e, st) {
      // Log any errors that occur during loading or parsing.
      developer.log(
        'Failed to load or parse default words from asset: $defaultAssetPath',
        error: e,
        stackTrace: st,
      );
      // Return an empty list to ensure the app can continue running.
      return [];
    }
  }

  /// Loads all words from all known JSON asset files.
  ///
  /// This method attempts to load words from `default_words.json`, `ielts_words.json`,
  /// and `toefl_words.json`. It combines all successfully loaded words into a single list.
  /// Duplicate words are removed to ensure a unique collection.
  Future<List<Word>> loadAllWords() async {
    final List<String> assetPaths = [
      'assets/data/default_words.json',
      'assets/data/ielts_words.json',
      'assets/data/toefl_words.json',
    ];

    final Set<Word> allWords = {};

    for (final path in assetPaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final List<dynamic> data = json.decode(jsonString);
        allWords.addAll(data.map((word) => Word(word: word.toString())));
        developer.log('Successfully loaded words from asset: $path');
      } catch (e, st) {
        developer.log(
          'Failed to load or parse words from asset: $path',
          error: e,
          stackTrace: st,
        );
      }
    }
    return allWords.toList();
  }
}
