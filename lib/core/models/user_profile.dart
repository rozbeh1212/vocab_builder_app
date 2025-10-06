import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 2) // Use a unique typeId
class UserProfile {
  @HiveField(0)
  String id;

  @HiveField(1)
  int experiencePoints;

  @HiveField(2)
  int level;

  @HiveField(3)
  int currentStreak;

  @HiveField(4)
  DateTime? lastLoginDate; // For streak calculation

  UserProfile({
    required this.id,
    this.experiencePoints = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.lastLoginDate,
  });

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
}
