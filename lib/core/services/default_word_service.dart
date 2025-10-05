import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DefaultWordService {
  Future<List<String>> loadDefaultWords() async {
    final String jsonString = await rootBundle.loadString('assets/data/default_words.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<String>();
  }
}
