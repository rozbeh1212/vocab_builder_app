import 'package:hive/hive.dart';
import 'package:vocab_builder_app/core/models/persian_context.dart';

part 'word_data.g.dart';

/// [WordData] stores comprehensive information about a word.
///
/// This model contains:
/// * Word definitions and meanings
/// * Usage examples
/// * Translations and contexts
/// * Related vocabulary
///
/// The data is typically populated from:
/// * AI-generated content
/// * User-provided information
/// * External dictionary sources
///
/// Features:
/// * Hive persistence support
/// * Rich text formatting
/// * Multi-language support
/// * Contextual information
@HiveType(typeId: 1)
class WordData {
  @HiveField(0)
  final String word;

  @HiveField(1)
  final String pronunciation;

  @HiveField(2)
  final String definition;

  @HiveField(3)
  final String example;

  @HiveField(4)
  final List<String> synonyms; // Added for synonyms

  @HiveField(5)
  final List<PersianContext> persianContexts;

  WordData({
    required this.word,
    required this.pronunciation,
    required this.definition,
    required this.example,
    required this.synonyms, // Added to constructor
    required this.persianContexts,
  });
}