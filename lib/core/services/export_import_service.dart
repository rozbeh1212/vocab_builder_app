import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import '../models/word.dart';

class ExportImportService {
  static const _srsBoxName = 'word_srs_box';

  static Future<String> exportData() async {
    try {
      final srsBox = await Hive.openBox(_srsBoxName);
      final words = srsBox.values.map((data) => Word.fromMap(Map<String, dynamic>.from(data))).toList();
      final exportData = {
        'version': '1.0',
        'timestamp': DateTime.now().toIso8601String(),
        'words': words.map((word) => word.toMap()).toList(),
      };

      final jsonString = jsonEncode(exportData);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/vocab_builder_backup.json');
      await file.writeAsString(jsonString);

      // Return the file path for manual sharing
      return file.path;
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  static Future<bool> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString);
      if (data['version'] == null || data['words'] == null) {
        throw Exception('Invalid backup file format');
      }

      final List<dynamic> wordsJson = data['words'];
      final List<Word> words = wordsJson
          .map((json) => Word.fromMap(json as Map<String, dynamic>))
          .toList();

      // Clear existing data and import new data
      final srsBox = await Hive.openBox(_srsBoxName);
      await srsBox.clear();
      for (final word in words) {
        await srsBox.put(word.word, word.toMap());
      }

      return true;
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }
}