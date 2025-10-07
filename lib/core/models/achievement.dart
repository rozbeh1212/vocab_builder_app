import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'achievement.g.dart';

/// [Achievement] represents an immutable model for a user-earned achievement.
///
/// This class is designed for persistence with Hive and includes details
/// such as the achievement's title, description, and the date it was earned.
@immutable
@HiveType(typeId: 3)
class Achievement {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime achievedDate;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.achievedDate,
  });

  /// Creates a copy of this [Achievement] instance with optional new values.
  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? achievedDate,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      achievedDate: achievedDate ?? this.achievedDate,
    );
  }

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, achievedDate: $achievedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Achievement &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.achievedDate == achievedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        achievedDate.hashCode;
  }
}