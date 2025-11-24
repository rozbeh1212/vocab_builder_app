import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocab_builder_app/core/constants/api_key.dart';
import 'package:vocab_builder_app/core/models/word_data.dart';
import 'package:vocab_builder_app/core/models/definition.dart';
import 'package:vocab_builder_app/core/models/phrasal_verb.dart';
import 'package:vocab_builder_app/core/models/common_collocation.dart';
import 'package:vocab_builder_app/core/models/preposition_usage.dart';
import 'package:vocab_builder_app/core/models/word_form.dart';
import 'package:vocab_builder_app/core/models/persian_context.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    if (geminiApiKey.isEmpty) {
      throw Exception('Gemini API Key is not set. Please set it in lib/core/constants/api_key.dart');
    }
    _model = GenerativeModel(model: 'gemini-pro', apiKey: geminiApiKey);
  }

  Future<WordData?> getWordDetails(String word) async {
    final prompt = """
      Provide detailed information for the word "$word" in a strict JSON format.
      The JSON should have the following structure:
      {
        "word": "the word itself",
        "definitions": [
          {
            "partOfSpeech": "noun/verb/etc.",
            "type": "type of definition (e.g., main, secondary)",
            "meaning": "the definition",
            "examples": ["example sentence 1", "example sentence 2"],
            "synonyms": ["synonym 1", "synonym 2"],
            "antonyms": ["antonym 1", "antonym 2"]
          }
        ],
        "phrasalVerbs": [
          {
            "verb": "phrasal verb",
            "meaning": "meaning of phrasal verb",
            "examples": ["example sentence 1"]
          }
        ],
        "commonCollocations": [
          {
            "collocation": "common collocation",
            "meaning": "meaning of collocation",
            "examples": ["example sentence 1"]
          }
        ],
        "prepositionUsages": [
          {
            "preposition": "preposition",
            "usage": "usage example",
            "examples": ["example sentence 1"]
          }
        ],
        "wordForms": [
          {
            "type": "noun/verb/adjective/adverb",
            "form": "word form"
          }
        ],
        "persianContexts": [
          {
            "context": "Persian translation or context",
            "examples": ["example sentence in Persian"]
          }
        ]
      }
      If any field is not applicable or no data is found, return an empty array for that field.
      Ensure the response is ONLY the JSON object, without any markdown formatting (e.g., ```json).
      """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        print('GeminiService: Received null response text for word: $word');
        return null;
      }

      // Clean the response to ensure it's a strict JSON string
      String cleanResponse = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();

      final jsonResponse = json.decode(cleanResponse);
      return WordData.fromJson(jsonResponse);
    } catch (e) {
      print('GeminiService Error fetching details for "$word": $e');
      return null;
    }
  }
}