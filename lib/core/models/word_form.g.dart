// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_form.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordFormAdapter extends TypeAdapter<WordForm> {
  @override
  final int typeId = 3;

  @override
  WordForm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordForm(
      formType: fields[0] as String,
      word: fields[1] as String,
      meaning: fields[2] as String,
      example: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordForm obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.formType)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.meaning)
      ..writeByte(3)
      ..write(obj.example);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordFormAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordForm _$WordFormFromJson(Map<String, dynamic> json) => WordForm(
      formType: json['formType'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      example: json['example'] as String,
    );

Map<String, dynamic> _$WordFormToJson(WordForm instance) => <String, dynamic>{
      'formType': instance.formType,
      'word': instance.word,
      'meaning': instance.meaning,
      'example': instance.example,
    };
