import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 3) // Use a unique typeId
class Achievement {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime achievedDate;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.achievedDate,
  });

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
}
