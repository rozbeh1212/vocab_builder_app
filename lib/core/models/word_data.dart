import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vocab_builder_app/core/models/persian_context.dart'; // Import PersianContext

part 'word_data.g.dart';

@HiveType(typeId: 1) // Unique typeId for WordData
@JsonSerializable()
class WordData extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final String? meaning;
  @HiveField(2)
  final String? example;
  @HiveField(3)
  final String? pronunciation;
  @HiveField(4)
  final List<String>? synonyms;
  @HiveField(5)
  final List<String>? antonyms;
  @HiveField(6)
  final String? imageUrl;
  @HiveField(7)
  final String? audioUrl;
  @HiveField(8) // New field
  final String? definition;
  @HiveField(9) // New field
  final List<PersianContext>? persianContexts;

  WordData({
    required this.word,
    this.meaning,
    this.example,
    this.pronunciation,
    this.synonyms,
    this.antonyms,
    this.imageUrl,
    this.audioUrl,
    this.definition, // New field
    this.persianContexts, // New field
  });

  factory WordData.fromJson(Map<String, dynamic> json) => _$WordDataFromJson(json);
  Map<String, dynamic> toJson() => _$WordDataToJson(this);

  WordData copyWith({
    String? word,
    String? meaning,
    String? example,
    String? pronunciation,
    List<String>? synonyms,
    List<String>? antonyms,
    String? imageUrl,
    String? audioUrl,
    String? definition, // New field
    List<PersianContext>? persianContexts, // New field
  }) {
    return WordData(
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      example: example ?? this.example,
      pronunciation: pronunciation ?? this.pronunciation,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      definition: definition ?? this.definition, // New field
      persianContexts: persianContexts ?? this.persianContexts, // New field
    );
  }

  @override
  String toString() {
    return 'WordData(word: $word, meaning: $meaning, example: $example, pronunciation: $pronunciation, synonyms: $synonyms, antonyms: $antonyms, imageUrl: $imageUrl, audioUrl: $audioUrl, definition: $definition, persianContexts: $persianContexts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WordData &&
        other.word == word &&
        other.meaning == meaning &&
        other.example == example &&
        other.pronunciation == pronunciation &&
        listEquals(other.synonyms, synonyms) &&
        listEquals(other.antonyms, antonyms) &&
        other.imageUrl == imageUrl &&
        other.audioUrl == audioUrl &&
        other.definition == definition &&
        listEquals(other.persianContexts, persianContexts);
  }

  @override
  int get hashCode {
    return word.hashCode ^
        meaning.hashCode ^
        example.hashCode ^
        pronunciation.hashCode ^
        synonyms.hashCode ^
        antonyms.hashCode ^
        imageUrl.hashCode ^
        audioUrl.hashCode ^
        definition.hashCode ^
        persianContexts.hashCode;
  }
}
