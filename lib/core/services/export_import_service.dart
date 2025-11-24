import 'dart:convert';
import 'dart:developer' as developer;
import '../models/word_data.dart';
import '../models/word_srs.dart';
import 'cache_service.dart';

/// [ExportImportService] provides functionality to export user vocabulary data
/// to a JSON format and import it back into the application.
///
/// This service is platform-agnostic; it generates or processes a JSON string,
/// leaving the file handling (saving/loading) to the UI layer, which can
/// use platform-specific packages like `share_plus` or `file_picker`.
class ExportImportService {
  final CacheService _cacheService = CacheService.instance;

  /// Exports all user vocabulary data, including SRS progress and word details,
  /// into a single JSON string.
  ///
  /// Returns a `Future<String>` containing the JSON data.
  /// Throws an exception if the export process fails.
  Future<String> exportData() async {
    try {
      final List<WordSRS> srsList = await _cacheService.getAllWordSRS();
      final List<WordData> detailsList = [];

      for (final srs in srsList) {
        final details = await _cacheService.getWordDetails(srs.word);
        if (details != null) {
          detailsList.add(details);
        }
      }

      final exportData = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'srs_data': srsList.map((srs) => srs.toJson()).toList(),
        'details_data': detailsList.map((details) => details.toJson()).toList(),
      };

      // Using JsonEncoder for pretty printing makes the output human-readable.
      return const JsonEncoder.withIndent('  ').convert(exportData);
    } catch (e, st) {
      developer.log('Failed to export data', error: e, stackTrace: st);
      throw Exception('Data export failed. Please try again.');
    }
  }

  /// Imports data from a JSON string, overwriting existing vocabulary data.
  ///
  /// [jsonString]: The JSON data to import.
  ///
  /// Returns a `Future<bool>` indicating whether the import was successful.
  /// Throws an exception if the data format is invalid or if the import fails.
  Future<bool> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Basic validation of the imported file format.
      if (data['version'] == null ||
          data['srs_data'] == null ||
          data['details_data'] == null) {
        throw const FormatException('Invalid backup file format.');
      }

      final List<dynamic> srsJson = data['srs_data'];
      final List<dynamic> detailsJson = data['details_data'];

      final List<WordSRS> srsList = srsJson
          .map((json) => WordSRS.fromJson(json as Map<String, dynamic>))
          .toList();
      final List<WordData> detailsList = detailsJson
          .map((json) => WordData.fromJson(json as Map<String, dynamic>))
          .toList();

      // Clear existing data before importing.
      await _cacheService.clearAllData();

      // Import the new data.
      for (final srs in srsList) {
        await _cacheService.saveWordSRS(srs);
      }
      for (final details in detailsList) {
        await _cacheService.saveWordDetails(details.word, details);
      }

      developer.log('Successfully imported ${srsList.length} words.');
      return true;
    } catch (e, st) {
      developer.log('Failed to import data', error: e, stackTrace: st);
      throw Exception('Data import failed. The file may be corrupt or in the wrong format.');
    }
  }

}
