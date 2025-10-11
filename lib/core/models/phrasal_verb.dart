import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'phrasal_verb.g.dart';

@HiveType(typeId: 4) // Using a new, unused typeId
@JsonSerializable()
class PhrasalVerb with EquatableMixin {
  @HiveField(0)
  final String verb;
  @HiveField(1)
  final String meaning;
  @HiveField(2)
  final String example;

  const PhrasalVerb({
    required this.verb,
    required this.meaning,
    required this.example,
  });

  factory PhrasalVerb.fromJson(Map<String, dynamic> json) => _$PhrasalVerbFromJson(json);
  Map<String, dynamic> toJson() => _$PhrasalVerbToJson(this);

  @override
  List<Object> get props => [verb, meaning, example];
}
