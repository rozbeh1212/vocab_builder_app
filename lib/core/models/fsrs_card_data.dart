import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

part 'fsrs_card_data.g.dart';

/// [FsrsCardData] represents an immutable model for spaced repetition data
/// using a Free Spaced Repetition Scheduler (FSRS) approach.
///
/// This class is designed for persistence with Hive and is currently a placeholder
/// for a more advanced FSRS implementation. It tracks core scheduling parameters.
@immutable
@HiveType(typeId: 100)
class FsrsCardData {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime dueDate;

  @HiveField(2)
  final double ease;

  @HiveField(3)
  final int intervalDays;

  @HiveField(4)
  final int repetitions;

  @HiveField(5)
  final double difficulty;

  const FsrsCardData({
    required this.id,
    required this.dueDate,
    required this.ease,
    required this.intervalDays,
    required this.repetitions,
    required this.difficulty,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FsrsCardData &&
      other.id == id &&
      other.dueDate == dueDate &&
      other.ease == ease &&
      other.intervalDays == intervalDays &&
      other.repetitions == repetitions &&
      other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      dueDate.hashCode ^
      ease.hashCode ^
      intervalDays.hashCode ^
      repetitions.hashCode ^
      difficulty.hashCode;
  }

  @override
  String toString() {
    return 'FsrsCardData(id: $id, dueDate: $dueDate, ease: $ease, intervalDays: $intervalDays, repetitions: $repetitions, difficulty: $difficulty)';
  }
}