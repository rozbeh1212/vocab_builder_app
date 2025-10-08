import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../constants/api_key.dart';
import '../models/word_data.dart';
import '../models/persian_context.dart';

/// [GeminiService] interacts with Google's Gemini AI to provide word details.
///
/// This service:
/// * Fetches comprehensive word information
/// * Provides context-aware translations
/// * Generates example sentences
/// * Offers synonyms and related words
///
/// The service uses Gemini's latest language model to ensure:
/// * High-quality translations
/// * Natural language examples
/// * Accurate word usage information
/// * Context-appropriate definitions
///
/// API Response includes:
/// * Word definitions in both languages
/// * Usage examples
/// * Persian translations and context
/// * Related vocabulary and collocations
class GeminiService {
  final String _apiKey = geminiApiKey;
  final String _model = 'gemini-2.0-flash';

  Future<WordData?> getWordDetails(String word) async {
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey');

  
    final prompt = """
      Provide detailed information for the English word "$word". The response must be a single, raw JSON object without any markdown formatting, comments, or surrounding text.

      The JSON object must adhere to the following strict structure:
      {
        "word": "...",
        "pronunciation": "...",
        "definition": "...",
        "example": "...",
        "synonyms": ["...", "..."],
        "persian_contexts": [
          {
            "persian_translation": "...",
            "persian_example": "...",
            "usage_notes": "...",
            "collocations": ["...", "..."],
            "preposition_usage": "..."
          },
          {
            "persian_translation": "...",
            "persian_example": "...",
            "usage_notes": "...",
            "collocations": ["...", "..."],
            "preposition_usage": "..."
          }
        ]
      }

      Rules:
      - Provide exactly one English definition and one main English example.
      - Provide exactly two distinct Persian contexts.
      - Ensure all keys are present, even if their values are empty arrays or empty strings.
      - The "word" key in the JSON should be the exact word requested.
      - Do not include backticks (```json), markdown, or any text outside of the JSON object itself.
    """;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final candidates = responseBody['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No candidates found in Gemini response.');
        }
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts == null || parts.isEmpty) {
          throw Exception('No parts found in Gemini response content.');
        }
        String jsonString = parts[0]['text'] as String;
        // Remove markdown code block delimiters if present
        if (jsonString.startsWith('```json')) {
          jsonString = jsonString.substring(7);
        }
        if (jsonString.endsWith('```')) {
          jsonString = jsonString.substring(0, jsonString.length - 3);
        }
        
        return _parseWordDataFromJson(jsonString.trim());
      } else {
        developer.log(
          'Gemini API Error: ${response.statusCode}\nResponse Body: ${response.body}',
          name: 'GeminiService',
          error: response.body,
        );
        return null;
      }
    } catch (e, st) {
      developer.log(
        'An error occurred while calling Gemini API: $e',
        name: 'GeminiService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Parses the JSON string from the API into a [WordData] object.
  ///
  /// This method includes robust error handling for missing keys and incorrect types
  /// by providing default empty values. It also logs the problematic JSON string
  /// in case of a parsing error to aid in debugging API response format issues.
  WordData _parseWordDataFromJson(String jsonString) {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString.trim());

      final contextsFromJson = jsonMap['persian_contexts'] as List?;
      final List<PersianContext> persianContexts = contextsFromJson
              ?.map((contextJson) {
                final map = contextJson as Map<String, dynamic>;
                return PersianContext(
                  meaning: map['persian_translation'] ?? '',
                  example: map['persian_example'] ?? '',
                  usageNotes: map['usage_notes'],
                  collocations: List<String>.from(map['collocations'] ?? []),
                  prepositionUsage: map['preposition_usage'],
                );
              })
              .toList() ??
          [];

      return WordData(
        word: jsonMap['word'] ?? '',
        pronunciation: jsonMap['pronunciation'] ?? '',
        definition: jsonMap['definition'] ?? '',
        example: jsonMap['example'] ?? '',
        synonyms: List<String>.from(jsonMap['synonyms'] ?? []),
        persianContexts: persianContexts,
        // Explicitly map 'definition' from the API response to 'meaning' in WordData
        // if a separate 'meaning' field is not provided by the API.
        meaning: jsonMap['definition'] ?? '',
      );
    } catch (e, st) {
      developer.log(
        'Failed to parse JSON response: $e. Problematic JSON: $jsonString',
        name: 'GeminiService',
        error: e,
        stackTrace: st,
      );
      // Re-throw the exception to be handled by the caller, providing context.
      throw FormatException('Invalid JSON format received from API: $e');
    }
  }
}
