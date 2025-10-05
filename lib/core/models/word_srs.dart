import 'package:hive/hive.dart';

part 'word_srs.g.dart';

/// [WordSRS] represents a word's spaced repetition learning data.
///
/// This model tracks:
/// * The word being learned
/// * Next review date
/// * Learning progress metrics
/// * Spaced repetition parameters
///
/// The model is used by the SRS system to:
/// * Schedule reviews
/// * Track learning progress
/// * Adjust intervals based on performance
/// * Maintain learning history
///
/// This class is annotated for Hive persistence and includes:
/// * Automatic type adaptation
/// * Efficient serialization
/// * Type-safe storage
@HiveType(typeId: 0)
class WordSRS {
  @HiveField(0)
  String word;

  @HiveField(1)
  DateTime dueDate;

  @HiveField(2)
  int repetition;

  @HiveField(3)
  int interval; // in days

  @HiveField(4)
  double efactor;

  WordSRS({
    required this.word,
    required this.dueDate,
    this.repetition = 0,
    this.interval = 0,
    this.efactor = 2.5,
  });

  /// Create a copy of this WordSRS optionally overriding fields.
  WordSRS copyWith({
    String? word,
    DateTime? dueDate,
    int? repetition,
    int? interval,
    double? efactor,
  }) {
    return WordSRS(
      word: word ?? this.word,
      dueDate: dueDate ?? this.dueDate,
      repetition: repetition ?? this.repetition,
      interval: interval ?? this.interval,
      efactor: efactor ?? this.efactor,
    );
  }
}
