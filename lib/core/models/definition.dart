import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'definition.g.dart';

@HiveType(typeId: 2) // Unique typeId for Definition
@JsonSerializable()
class Definition extends HiveObject {
  @HiveField(0)
  final String? partOfSpeech;
  @HiveField(1)
  final String? meaning;
  @HiveField(2)
  final String? example;
  @HiveField(3)
  final String? frequency;

  Definition({
    this.partOfSpeech,
    this.meaning,
    this.example,
    this.frequency,
  });

  factory Definition.fromJson(Map<String, dynamic> json) => _$DefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$DefinitionToJson(this);

  @override
  String toString() {
    return 'Definition(partOfSpeech: $partOfSpeech, meaning: $meaning, example: $example, frequency: $frequency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Definition &&
        other.partOfSpeech == partOfSpeech &&
        other.meaning == meaning &&
        other.example == example &&
        other.frequency == frequency;
  }

  @override
  int get hashCode {
    return partOfSpeech.hashCode ^
        meaning.hashCode ^
        example.hashCode ^
        frequency.hashCode;
  }
}
