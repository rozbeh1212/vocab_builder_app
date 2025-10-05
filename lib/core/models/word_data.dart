import 'package:hive/hive.dart';
import 'package:vocab_builder_app/core/models/persian_context.dart';

part 'word_data.g.dart';

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