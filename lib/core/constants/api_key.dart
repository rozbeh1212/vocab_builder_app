/// NOTE: For testing only — this file temporarily contains a hardcoded
/// Gemini API key at the user's request. Remove this value before
/// committing to a public repository or production use.
const String geminiApiKey = 'AIzaSyAMzLPKPFPv_xdNXpT30JZ2YuCyhEgmn9E';

/// A simple check to ensure the API key is provided at runtime.
void validateApiKey() {
  if (geminiApiKey.isEmpty) {
    throw Exception('Gemini API key is not provided.');
  }
}