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

      // Cast the dynamic list to a list of strings and return it.
      return jsonList.cast<String>();
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
}
