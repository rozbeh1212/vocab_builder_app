import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vocab_builder_app/core/models/word.dart';

/// [WordService] manages loading predefined word lists from JSON assets.
///
/// This service is responsible for:
/// - Loading word lists for categories like IELTS and TOEFL from the app's assets.
/// - Parsing the JSON data into a list of [Word] objects.
/// - Handling potential errors during asset loading and parsing.
class WordService {
  /// Loads a list of words for a given [category] from a JSON asset file.
  ///
  /// The method expects asset files to be located at `assets/data/{category}_words.json`.
  /// For example, for the category 'ielts', it will load `assets/data/ielts_words.json`.
  ///
  /// Returns a `Future<List<Word>>`. If the asset fails to load or parse,
  /// it logs the error and returns an empty list to prevent crashes.
  Future<List<Word>> loadWords(String category) async {
    // Construct the correct asset path based on the category.
    // Assumes category names match the file names (e.g., 'ielts' -> 'ielts_words.json').
    final String assetPath = 'assets/data/${category.toLowerCase()}_words.json';
    try {
      // Load the JSON file as a string from the root bundle.
      final String jsonString = await rootBundle.loadString(assetPath);
      developer.log('Successfully loaded words from asset: $assetPath');

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
        'Failed to load or parse words from asset: $assetPath',
        error: e,
        stackTrace: st,
      );
      // Return an empty list to ensure the app can continue running.
      return [];
    }
  }
}