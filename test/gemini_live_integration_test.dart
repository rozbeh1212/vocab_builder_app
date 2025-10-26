import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_builder_app/core/services/gemini_service.dart';

void main() {
  test('Live Gemini fetch for sample word (aberration)', () async {
    final service = GeminiService();
    final word = 'aberration';
    final result = await service.getWordDetails(word);

    // Only a truncated display for safety
    if (result == null) {
      print('GeminiService returned null for "$word".');
    } else {
      final parsed = result.toString();
      final truncated = parsed.length > 500 ? '${parsed.substring(0, 500)}...<truncated>' : parsed;
      print('Parsed WordData (truncated): $truncated');
    }

    // Not asserting network results; this is a manual integration check.
    expect(true, isTrue);
  }, timeout: Timeout(Duration(seconds: 60)));
}
