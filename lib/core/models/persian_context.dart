import 'package:hive/hive.dart';

part 'persian_context.g.dart';

/// [PersianContext] represents Persian language context for vocabulary words.
///
/// This model stores:
/// * Persian translations
/// * Usage contexts
/// * Cultural notes
/// * Language-specific examples
///
/// The context helps users:
/// * Understand word usage in Persian
/// * Learn cultural context
/// * Practice translation
/// * Build connections between languages
///
/// Features:
/// * Bidirectional text support
/// * Cultural context preservation
/// * Multiple translation support
/// * Rich example formatting
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
