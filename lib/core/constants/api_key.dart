/// This file contains the API key for the Gemini service.
///
/// WARNING: Do not commit this file with a real API key to a public repository.
/// It is highly recommended to use environment variables or a secure secret
/// management solution for production applications. For the purpose of this
/// review, the key is hardcoded as requested.
const String geminiApiKey = 'AIzaSyAMzLPKPFPv_xdNXpT30JZ2YuCyhEgmn9E';

/// A simple check to ensure the API key is provided.
/// In a real application, you might want to handle this more gracefully,
/// for example, by disabling AI-related features if the key is missing.
void validateApiKey() {
  if (geminiApiKey.isEmpty) {
    throw Exception('Gemini API key is not provided.');
  }
}