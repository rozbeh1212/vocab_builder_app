import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// [UserProfile] is an immutable model representing the user's profile data.
///
/// This class is designed for persistence with Hive and stores progress metrics
/// like experience points, level, and daily streaks.
@immutable
@HiveType(typeId: 2)
class UserProfile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int experiencePoints;

  @HiveField(2)
  final int level;

  @HiveField(3)
  final int currentStreak;

  @HiveField(4)
  final DateTime? lastLoginDate;

  const UserProfile({
    required this.id,
    this.experiencePoints = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.lastLoginDate,
  });

  /// Creates a copy of this [UserProfile] instance with optional new values.
  UserProfile copyWith({
    String? id,
    int? experiencePoints,
    int? level,
    int? currentStreak,
    DateTime? lastLoginDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, experiencePoints: $experiencePoints, level: $level, currentStreak: $currentStreak, lastLoginDate: $lastLoginDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.id == id &&
        other.experiencePoints == experiencePoints &&
        other.level == level &&
        other.currentStreak == currentStreak &&
        other.lastLoginDate == lastLoginDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        experiencePoints.hashCode ^
        level.hashCode ^
        currentStreak.hashCode ^
        lastLoginDate.hashCode;
  }
}