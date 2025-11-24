import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;

/// [DefaultWordService] is responsible for loading the initial list of
/// default words that can be pre-loaded into the application.
///
/// This service reads a predefined list of words from a JSON file included
/// in the application's assets.
class DefaultWordService {
  /// Loads a list of words from a specified asset path.
  ///
  /// [assetPath]: The full path to the JSON file within the assets folder (e.g., 'assets/data/ielts_words.json').
  /// Returns a `Future<List<String>>` containing the list of words.
  /// In case of an error (e.g., file not found, malformed JSON), it logs
  /// the error and returns an empty list to prevent the app from crashing.
  Future<List<String>> loadWordsFromAsset(String assetPath) async {
    try {
      // Load the JSON file as a string from the application's assets.
      final String jsonString = await rootBundle.loadString(assetPath);

      // Decode the JSON string into a list of dynamic objects.
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // The asset may contain either a list of plain words (strings)
      // or a list of detailed word objects. Normalize both formats
      // into a simple List<String> of the word keys.
      final List<String> words = [];
      for (final item in jsonList) {
        if (item is String) {
          words.add(item);
        } else if (item is Map<String, dynamic> && item.containsKey('word')) {
          final w = item['word'];
          if (w is String) words.add(w);
        }
      }
      return words;
    } catch (e, st) {
      // Log any errors that occur during the file loading or parsing process.
      developer.log(
        'Failed to load words from asset: $assetPath',
        error: e,
        stackTrace: st,
      );
      // Return an empty list to ensure the application remains stable.
      return [];
    }
  }

  /// Loads a detailed word object (map) for a given [word] from known asset files.
  ///
  /// Returns the decoded Map<String, dynamic> if found, otherwise null.
  Future<Map<String, dynamic>?> loadWordDetails(String word) async {
    final normalized = word.trim().toLowerCase();
    final List<String> assetPaths = [
      'assets/data/default_words.json',
      'assets/data/ielts_words.json',
      'assets/data/toefl_words.json',
    ];

    for (final path in assetPaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final List<dynamic> data = jsonDecode(jsonString);
        for (final item in data) {
          if (item is Map<String, dynamic>) {
            final w = (item['word'] ?? '').toString().toLowerCase();
            if (w == normalized) return item;
          }
        }
      } catch (e, st) {
        developer.log('Failed to read $path while searching for details for $word', error: e, stackTrace: st);
      }
    }
    return null;
  }
}
