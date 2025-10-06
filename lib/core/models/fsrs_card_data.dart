import 'package:hive/hive.dart';

part 'fsrs_card_data.g.dart';

@HiveType(typeId: 100)
class FsrsCardData extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime dueDate;

  @HiveField(2)
  final double ease; // e factor or similar

  @HiveField(3)
  final int intervalDays;

  @HiveField(4)
  final int repetitions;

  @HiveField(5)
  final double difficulty;

  FsrsCardData({
    required this.id,
    required this.dueDate,
    required this.ease,
    required this.intervalDays,
    required this.repetitions,
    required this.difficulty,
  });
}
