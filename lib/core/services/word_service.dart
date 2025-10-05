import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vocab_builder_app/core/models/word.dart';

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
