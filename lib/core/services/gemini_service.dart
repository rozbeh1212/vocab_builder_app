import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_key.dart';
import '../models/definition.dart';
import '../models/word_data.dart';
import '../models/persian_context.dart';
import '../models/word_form.dart'; // Import WordForm
import '../models/phrasal_verb.dart'; // Import PhrasalVerb

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
        "phrasal_verbs": [
          {
            "verb": "give up",
            "meaning": "To stop trying to do something.",
            "example": "He decided to give up smoking."
          },
          {
            "verb": "give in",
            "meaning": "To finally agree to what someone wants.",
            "example": "She wouldn't give in to his demands."
          }
        ],
        "word_forms": [
          {
            "form_type": "Noun",
            "word": "creation",
            "meaning": "The action or process of bringing something into existence.",
            "example": "The creation of a new constitution was a long process."
          },
          {
            "form_type": "Adjective",
            "word": "creative",
            "meaning": "Relating to or involving the imagination or original ideas.",
            "example": "She has a very creative approach to problem-solving."
          }
        ],
        "mnemonic": "A short, clever sentence to help remember the word.",
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

      if (kDebugMode) {
        developer.log('Gemini API Response Status Code: ${response.statusCode}', name: 'GeminiService');
  // Avoid logging full response bodies in production; truncate for debug.
  final body = response.body;
        final truncated = body.length > 300 ? '${body.substring(0, 300)}...<truncated>' : body;
        developer.log('Gemini API Response Body (truncated): $truncated', name: 'GeminiService');
      }

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final candidates = responseBody['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          developer.log('No candidates found in Gemini response.', name: 'GeminiService');
          throw Exception('No candidates found in Gemini response.');
        }
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts == null || parts.isEmpty) {
          developer.log('No parts found in Gemini response content.', name: 'GeminiService');
          throw Exception('No parts found in Gemini response content.');
        }
        String jsonString = parts[0]['text'] as String;
        if (kDebugMode) {
          // Show only a safe/truncated preview in debug.
          final preview = jsonString.length > 500 ? '${jsonString.substring(0, 500)}...<truncated>' : jsonString;
          developer.log('Raw JSON string preview from Gemini: $preview', name: 'GeminiService');
        }

        // Remove markdown code block delimiters if present
        jsonString = jsonString.replaceAll(RegExp(r'```json|```'), '');
        
        return _parseWordDataFromJson(jsonString.trim());
      } else {
        if (kDebugMode) {
          final body = response.body;
          final truncated = body.length > 300 ? '${body.substring(0, 300)}...<truncated>' : body;
          developer.log('Gemini API Error: ${response.statusCode}\nResponse Body (truncated): $truncated', name: 'GeminiService');
        } else {
          developer.log('Gemini API Error: ${response.statusCode}', name: 'GeminiService');
        }
        return null;
      }
    } catch (e, st) {
      if (kDebugMode) {
        developer.log(
          'An error occurred while calling Gemini API: $e',
          name: 'GeminiService',
          error: e,
          stackTrace: st,
        );
      } else {
        developer.log('An error occurred while calling Gemini API: $e', name: 'GeminiService');
      }
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
                if (contextJson is Map<String, dynamic>) {
                  return PersianContext(
                    meaning: contextJson['persian_translation'] as String? ?? '',
                    example: contextJson['persian_example'] as String? ?? '',
                    usageNotes: contextJson['usage_notes'] as String?,
                    collocations: (contextJson['collocations'] as List?)?.whereType<String>().toList(),
                    prepositionUsage: contextJson['preposition_usage'] as String?,
                  );
                }
                return null; // Skip invalid entries
              })
              .whereType<PersianContext>() // Filter out nulls
              .toList() ??
          [];

      // Manually parse WordForm to handle potential nulls gracefully
      final wordFormsFromJson = jsonMap['word_forms'] as List?;
      final List<WordForm> wordForms = [];
      if (wordFormsFromJson != null) {
        for (var formJson in wordFormsFromJson) {
          if (formJson is Map<String, dynamic>) {
            wordForms.add(WordForm(
              formType: formJson['form_type'] as String? ?? '',
              word: formJson['word'] as String? ?? '',
              meaning: formJson['meaning'] as String? ?? '',
              example: formJson['example'] as String? ?? '',
            ));
          }
        }
      }

      // Manually parse PhrasalVerb to handle potential nulls gracefully
      final phrasalVerbsFromJson = jsonMap['phrasal_verbs'] as List?;
      final List<PhrasalVerb> phrasalVerbs = [];
      if (phrasalVerbsFromJson != null) {
        for (var pvJson in phrasalVerbsFromJson) {
          if (pvJson is Map<String, dynamic>) {
            phrasalVerbs.add(PhrasalVerb(
              verb: pvJson['verb'] as String? ?? '',
              meaning: pvJson['meaning'] as String? ?? '',
              example: pvJson['example'] as String? ?? '',
            ));
          }
        }
      }

      // Create a Definition object from the main definition and example.
      final mainDefinition = Definition(
        meaning: jsonMap['definition'] as String?,
        example: jsonMap['example'] as String?,
      );

      return WordData(
        word: jsonMap['word'] as String? ?? '',
        pronunciation: jsonMap['pronunciation'] as String?,
        definitions: [mainDefinition], // Use the new definitions list
        example: jsonMap['example'] as String?,
        synonyms: (jsonMap['synonyms'] as List?)?.whereType<String>().toList(),
        phrasalVerbs: phrasalVerbs,
        wordForms: wordForms,
        persianContexts: persianContexts,
        mnemonic: jsonMap['mnemonic'] as String?,
        // The main 'meaning' can be sourced from the primary definition.
        meaning: jsonMap['definition'] as String?,
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
