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
      definitions: (fields[8] as List?)?.cast<Definition>(),
      persianContexts: (fields[9] as List?)?.cast<PersianContext>(),
      phrasalVerbs: (fields[10] as List?)?.cast<PhrasalVerb>(),
      wordForms: (fields[11] as List?)?.cast<WordForm>(),
      mnemonic: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WordData obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.definitions)
      ..writeByte(9)
      ..write(obj.persianContexts)
      ..writeByte(10)
      ..write(obj.phrasalVerbs)
      ..writeByte(11)
      ..write(obj.wordForms)
      ..writeByte(12)
      ..write(obj.mnemonic);
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
      definitions: (json['definitions'] as List<dynamic>?)
          ?.map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
      persianContexts: (json['persianContexts'] as List<dynamic>?)
          ?.map((e) => PersianContext.fromJson(e as Map<String, dynamic>))
          .toList(),
      phrasalVerbs: (json['phrasalVerbs'] as List<dynamic>?)
          ?.map((e) => PhrasalVerb.fromJson(e as Map<String, dynamic>))
          .toList(),
      wordForms: (json['wordForms'] as List<dynamic>?)
          ?.map((e) => WordForm.fromJson(e as Map<String, dynamic>))
          .toList(),
      mnemonic: json['mnemonic'] as String?,
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
      'definitions': instance.definitions,
      'persianContexts': instance.persianContexts,
      'phrasalVerbs': instance.phrasalVerbs,
      'wordForms': instance.wordForms,
      'mnemonic': instance.mnemonic,
    };
