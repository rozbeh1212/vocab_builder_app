# API Keys and Secrets (Local setup)

This project uses an external AI service (Gemini). To avoid committing secrets to
source control, provide the Gemini API key at build/run time via a Dart define.

Examples:

- Run locally with the key:

```powershell
flutter run --dart-define=GEMINI_API_KEY=AIzaSy...YOUR_KEY...
```

- Build a release with the key:

```powershell
flutter build apk --dart-define=GEMINI_API_KEY=AIzaSy...YOUR_KEY...
```

Notes:
- Do NOT commit your real API keys into the repository.
- For CI, set the `GEMINI_API_KEY` as a secret environment variable and pass it via the build step.
- Alternatively, use a platform-specific secret manager (e.g., Keystore/Keychain, or remote secrets service) for production.
