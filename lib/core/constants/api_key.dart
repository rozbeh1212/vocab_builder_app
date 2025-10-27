/// Gemini API key retrieval.
///
/// Keys must be supplied at build/runtime via a compile-time define.
/// Example: flutter run --dart-define=GEMINI_API_KEY=your_key_here
const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

/// Returns true when a key has been supplied via --dart-define.
bool hasGeminiApiKey() => geminiApiKey.isNotEmpty;