import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vocab_builder_app/core/models/word.dart';

/// [WordService] manages the loading and processing of word lists.
///
/// This service handles:
/// * Loading predefined word lists (IELTS, TOEFL)
/// * Converting raw data to Word objects
/// * Managing word categories and classifications
/// * Handling asset loading across platforms
///
/// Features:
/// * Efficient asset loading
/// * Error handling and logging
/// * Cross-platform compatibility
/// * Category-based word organization
class WordService {
  Future<List<Word>> loadWords(String category) async {
    final String assetPath = 'data/${category.toLowerCase()}_words.json';
    try {
      // Load the asset using the correct path
      final String response = await rootBundle.loadString('assets/$assetPath');
      developer.log('Successfully loaded words from assets/$assetPath');
      
      final List<dynamic> data = json.decode(response);
      return data.map((word) => Word(word: word.toString(), meaning: null, example: null)).toList();
    } catch (e, st) {
      developer.log('Failed to load words from assets/$assetPath: $e', stackTrace: st);
      // Return an empty list instead of throwing to avoid crashes
      return [];
    }
  }
}
