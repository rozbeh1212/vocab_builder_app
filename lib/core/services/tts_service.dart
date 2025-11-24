import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer' as developer;

class TTSService {
  static final TTSService _instance = TTSService._internal();
  late FlutterTts _flutterTts;
  bool _isInitialized = false;

  factory TTSService() {
    return _instance;
  }

  TTSService._internal() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      developer.log("TTS: Speech Started", name: 'TTSService');
    });

    _flutterTts.setCompletionHandler(() {
      developer.log("TTS: Speech Completed", name: 'TTSService');
    });

    _flutterTts.setErrorHandler((msg) {
      developer.log("TTS Error: $msg", name: 'TTSService', error: msg);
    });
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) {
      developer.log("TTS: Cannot speak empty text.", name: 'TTSService');
      return;
    }
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Dispose method to release resources, if needed (e.g., on app shutdown)
  void dispose() {
    _flutterTts.stop();
  }
}