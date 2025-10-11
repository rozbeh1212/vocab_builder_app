import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'word_form.g.dart';

@HiveType(typeId: 3) // Using a new, unused typeId
@JsonSerializable()
class WordForm with EquatableMixin {
  @HiveField(0)
  final String formType;
  @HiveField(1)
  final String word;
  @HiveField(2)
  final String meaning;
  @HiveField(3)
  final String example;

  const WordForm({
    required this.formType,
    required this.word,
    required this.meaning,
    required this.example,
  });

  factory WordForm.fromJson(Map<String, dynamic> json) => _$WordFormFromJson(json);
  Map<String, dynamic> toJson() => _$WordFormToJson(this);

  @override
  List<Object> get props => [formType, word, meaning, example];
}
