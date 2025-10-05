import 'package:hive/hive.dart';

part 'word_srs.g.dart';

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
