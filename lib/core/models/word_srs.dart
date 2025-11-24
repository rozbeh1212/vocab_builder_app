import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'word_srs.g.dart';

/// [WordSRS] represents the spaced repetition learning data for a single word.
///
/// This model is immutable and designed for persistence with Hive. It tracks all
/// essential parameters for the SM-2 algorithm, including the next review date,
/// the number of repetitions, the interval between reviews, and the ease factor.
@immutable
@HiveType(typeId: 0)
@JsonSerializable()
class WordSRS {
  /// The word being learned.
  @HiveField(0)
  final String word;

  /// The next date the word is scheduled for review.
  @HiveField(1)
  final DateTime dueDate;

  /// The number of times the word has been successfully recalled in a row.
  @HiveField(2)
  final int repetition;

  /// The current interval in days until the next review.
  @HiveField(3)
  final int interval;

  /// The ease factor (E-Factor), which determines how quickly the interval grows.
  @HiveField(4)
  final double efactor;

  const WordSRS({
    required this.word,
    required this.dueDate,
    this.repetition = 0,
    this.interval = 0,
    this.efactor = 2.5,
  });

  factory WordSRS.fromJson(Map<String, dynamic> json) => _$WordSRSFromJson(json);
  Map<String, dynamic> toJson() => _$WordSRSToJson(this);

  /// Creates a copy of this [WordSRS] instance with the given fields replaced
  /// with new values.
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

  @override
  String toString() {
    return 'WordSRS(word: $word, dueDate: $dueDate, repetition: $repetition, interval: $interval, efactor: $efactor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WordSRS &&
        other.word == word &&
        other.dueDate == dueDate &&
        other.repetition == repetition &&
        other.interval == interval &&
        other.efactor == efactor;
  }

  @override
  int get hashCode {
    return word.hashCode ^
        dueDate.hashCode ^
        repetition.hashCode ^
        interval.hashCode ^
        efactor.hashCode;
  }
}
