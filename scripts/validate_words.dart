import 'dart:convert';
import 'dart:io';

final requiredTopLevelKeys = [
  'word',
  'persianMeaning',
  'phonetic',
  'definitions',
];

void main(List<String> args) async {
  final assetsDir = Directory('assets/data');
  if (!assetsDir.existsSync()) {
    stderr.writeln('assets/data directory not found. Run this script from the project root.');
    exit(2);
  }

  final files = assetsDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList();

  var hadError = false;
  for (final file in files) {
    stdout.writeln('Checking ${file.path}...');
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      if (data is List) {
        for (var i = 0; i < data.length; i++) {
          final item = data[i];
          if (item is! Map<String, dynamic>) {
            stderr.writeln('  [ERROR] Item $i is not an object.');
            hadError = true;
            continue;
          }
          for (final key in requiredTopLevelKeys) {
            if (!item.containsKey(key)) {
              stderr.writeln('  [ERROR] Item $i missing required key: $key');
              hadError = true;
            }
          }
          // definitions must be a list
          final defs = item['definitions'];
          if (defs != null && defs is! List) {
            stderr.writeln('  [ERROR] Item $i definitions is not a list');
            hadError = true;
          }
        }
      } else {
        stderr.writeln('  [ERROR] File root is not a JSON array.');
        hadError = true;
      }
    } catch (e) {
      stderr.writeln('  [ERROR] Failed to parse JSON: $e');
      hadError = true;
    }
  }

  if (hadError) {
    stderr.writeln('\nValidation failed. Fix the errors above.');
    exit(1);
  }

  stdout.writeln('\nAll JSON word files validated successfully.');
  exit(0);
}
