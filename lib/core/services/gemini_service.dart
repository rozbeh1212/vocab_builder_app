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
      Provide detailed information for the English word "$word", including English definitions with examples, synonyms, and comprehensive Persian context (translations, usage notes, collocations, preposition usage).
      The JSON object must have these exact keys: "word", "pronunciation", "definition", "example", "synonyms", and "persian_contexts".
      "synonyms" must be an array of strings.
      "persian_contexts" must be an array of objects, where each object has "persian_translation", "persian_example", "usage_notes", "collocations", and "preposition_usage" keys.
      "collocations" must be an array of strings.
      Provide only one definition and one main example. Provide 2 persian contexts.
      Do not include any text before or after the JSON object. Do not use markdown.
      
      Example for the word "integrate":
      {
        "word": "integrate",
        "pronunciation": "/ˈɪntəˌɡreɪt/",
        "definition": "To combine one thing with another so that they become a whole.",
        "example": "He didn't integrate well into the new team.",
        "synonyms": ["combine", "unite", "merge"],
        "persian_contexts": [
          {
            "persian_translation": "ادغام کردن",
            "persian_example": "ما باید سیستم جدید را با سیستم قدیمی ادغام کنیم.",
            "usage_notes": "معمولاً برای ترکیب دو یا چند چیز به یک کل واحد استفاده می‌شود.",
            "collocations": ["integrate into", "integrate with", "fully integrate"],
            "preposition_usage": "integrate into (a system), integrate with (a group)"
          },
          {
            "persian_translation": "یکپارچه ساختن",
            "persian_example": "هدف این پروژه یکپارچه ساختن خدمات مختلف است.",
            "usage_notes": "می‌تواند به معنای آوردن افراد یا گروه‌ها به یک جامعه یا سازمان باشد.",
            "collocations": ["integrate services", "integrate components"],
            "preposition_usage": "integrate into (society), integrate with (existing structures)"
          }
        ]
      }
    """;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contents': [{'parts': [{'text': prompt}]}]}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String jsonString = responseBody['candidates'][0]['content']['parts'][0]['text'];
        
        // Remove markdown code block delimiters if present
        if (jsonString.startsWith('```json')) {
          jsonString = jsonString.substring(7); // Remove '```json'
        }
        if (jsonString.endsWith('```')) {
          jsonString = jsonString.substring(0, jsonString.length - 3); // Remove '```'
        }
        
        return _parseWordDataFromJson(jsonString);
      } else {
        // Log the error with developer.log instead of printing.
        developer.log('Gemini API Error: ${response.statusCode}', name: 'GeminiService');
        developer.log('Response Body: ${response.body}', name: 'GeminiService');
        return null;
      }
    } catch (e) {
      // Handle network or other exceptions
      developer.log('An error occurred: $e', name: 'GeminiService');
      return null;
    }
  }

  WordData _parseWordDataFromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    
    var contextsFromJson = jsonMap['persian_contexts'] as List;
    List<PersianContext> persianContexts = contextsFromJson
        .map((contextJson) => PersianContext(
              meaning: contextJson['persian_translation'],
              example: contextJson['persian_example'],
              usageNotes: contextJson['usage_notes'],
              collocations: List<String>.from(contextJson['collocations'] ?? []), // Handle null or empty
              prepositionUsage: contextJson['preposition_usage'],
            ))
        .toList();

    return WordData(
      word: jsonMap['word'],
      pronunciation: jsonMap['pronunciation'],
      definition: jsonMap['definition'],
      example: jsonMap['example'],
      synonyms: List<String>.from(jsonMap['synonyms'] ?? []), // Handle null or empty
      persianContexts: persianContexts,
    );
  }
}