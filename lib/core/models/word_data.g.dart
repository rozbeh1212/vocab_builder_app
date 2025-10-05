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
      pronunciation: fields[1] as String,
      definition: fields[2] as String,
      example: fields[3] as String,
      synonyms: (fields[4] as List).cast<String>(),
      persianContexts: (fields[5] as List).cast<PersianContext>(),
    );
  }

  @override
  void write(BinaryWriter writer, WordData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.pronunciation)
      ..writeByte(2)
      ..write(obj.definition)
      ..writeByte(3)
      ..write(obj.example)
      ..writeByte(4)
      ..write(obj.synonyms)
      ..writeByte(5)
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
