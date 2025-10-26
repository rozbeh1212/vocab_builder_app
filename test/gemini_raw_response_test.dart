import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:vocab_builder_app/core/constants/api_key.dart';

void main() {
  test('Raw Gemini HTTP response (safe truncated)', () async {
    final apiKey = geminiApiKey;
    final model = 'gemini-2.0-flash';
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

    final prompt = '''Provide detailed information for the English word "aberration". Return only a JSON object.''';

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

      print('HTTP status: ${response.statusCode}');
      final body = response.body;
      final truncated = body.length > 800 ? '${body.substring(0, 800)}...<truncated>' : body;
      print('Response body (truncated 800 chars):\n$truncated');
    } catch (e) {
      print('Request failed: $e');
    }

    expect(true, isTrue);
  }, timeout: Timeout(Duration(seconds: 60)));
}
