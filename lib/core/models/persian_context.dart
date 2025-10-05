import 'package:hive/hive.dart';

part 'persian_context.g.dart';

@HiveType(typeId: 2)
class PersianContext {
  @HiveField(0)
  final String meaning;

  @HiveField(1)
  final String example;

  @HiveField(2)
  final String? usageNotes; // Added for usage notes

  @HiveField(3)
  final List<String>? collocations; // Added for collocations

  @HiveField(4)
  final String? prepositionUsage; // Added for preposition usage

  PersianContext({
    required this.meaning,
    required this.example,
    this.usageNotes,
    this.collocations,
    this.prepositionUsage,
  });
}
