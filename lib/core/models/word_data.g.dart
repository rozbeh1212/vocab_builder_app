// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordDataAdapter extends TypeAdapter<WordData> {
  @override
  final int typeId = 1;

  @override
  WordData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordData(
      word: fields[0] as String,
      meaning: fields[1] as String?,
      example: fields[2] as String?,
      pronunciation: fields[3] as String?,
      synonyms: (fields[4] as List?)?.cast<String>(),
      antonyms: (fields[5] as List?)?.cast<String>(),
      imageUrl: fields[6] as String?,
      audioUrl: fields[7] as String?,
      definition: fields[8] as String?,
      persianContexts: (fields[9] as List?)?.cast<PersianContext>(),
    );
  }

  @override
  void write(BinaryWriter writer, WordData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.example)
      ..writeByte(3)
      ..write(obj.pronunciation)
      ..writeByte(4)
      ..write(obj.synonyms)
      ..writeByte(5)
      ..write(obj.antonyms)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.audioUrl)
      ..writeByte(8)
      ..write(obj.definition)
      ..writeByte(9)
      ..write(obj.persianContexts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordData _$WordDataFromJson(Map<String, dynamic> json) => WordData(
      word: json['word'] as String,
      meaning: json['meaning'] as String?,
      example: json['example'] as String?,
      pronunciation: json['pronunciation'] as String?,
      synonyms: (json['synonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      antonyms: (json['antonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      definition: json['definition'] as String?,
      persianContexts: (json['persianContexts'] as List<dynamic>?)
          ?.map((e) => PersianContext.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WordDataToJson(WordData instance) => <String, dynamic>{
      'word': instance.word,
      'meaning': instance.meaning,
      'example': instance.example,
      'pronunciation': instance.pronunciation,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'definition': instance.definition,
      'persianContexts': instance.persianContexts,
    };
