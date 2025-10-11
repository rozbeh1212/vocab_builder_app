import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preposition_usage.g.dart';

@HiveType(typeId: 3) // Unique typeId for PrepositionUsage
@JsonSerializable()
class PrepositionUsage extends HiveObject {
  @HiveField(0)
  final String? preposition;
  @HiveField(1)
  final String? usagePattern;
  @HiveField(2)
  final String? meaning;
  @HiveField(3)
  final String? example;

  PrepositionUsage({
    this.preposition,
    this.usagePattern,
    this.meaning,
    this.example,
  });

  factory PrepositionUsage.fromJson(Map<String, dynamic> json) => _$PrepositionUsageFromJson(json);
  Map<String, dynamic> toJson() => _$PrepositionUsageToJson(this);

  @override
  String toString() {
    return 'PrepositionUsage(preposition: $preposition, usagePattern: $usagePattern, meaning: $meaning, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrepositionUsage &&
        other.preposition == preposition &&
        other.usagePattern == usagePattern &&
        other.meaning == meaning &&
        other.example == example;
  }

  @override
  int get hashCode {
    return preposition.hashCode ^
        usagePattern.hashCode ^
        meaning.hashCode ^
        example.hashCode;
  }
}
