import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phrasal_verb.g.dart';

@HiveType(typeId: 4) // Unique typeId for PhrasalVerb
@JsonSerializable()
class PhrasalVerb extends HiveObject {
  @HiveField(0)
  final String phrasalVerb;
  @HiveField(1)
  final String meaning;
  @HiveField(2)
  final String example;

  PhrasalVerb({
    required this.phrasalVerb,
    required this.meaning,
    required this.example,
  });

  factory PhrasalVerb.fromJson(Map<String, dynamic> json) => _$PhrasalVerbFromJson(json);
  Map<String, dynamic> toJson() => _$PhrasalVerbToJson(this);

  @override
  String toString() {
    return 'PhrasalVerb(phrasalVerb: $phrasalVerb, meaning: $meaning, example: $example)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhrasalVerb &&
        other.phrasalVerb == phrasalVerb &&
        other.meaning == meaning &&
        other.example == example;
  }

  @override
  int get hashCode {
    return phrasalVerb.hashCode ^
        meaning.hashCode ^
        example.hashCode;
  }
}
