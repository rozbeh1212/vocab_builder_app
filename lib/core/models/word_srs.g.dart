// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_srs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordSRSAdapter extends TypeAdapter<WordSRS> {
  @override
  final int typeId = 0;

  @override
  WordSRS read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordSRS(
      word: fields[0] as String,
      dueDate: fields[1] as DateTime,
      repetition: fields[2] as int,
      interval: fields[3] as int,
      efactor: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WordSRS obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.dueDate)
      ..writeByte(2)
      ..write(obj.repetition)
      ..writeByte(3)
      ..write(obj.interval)
      ..writeByte(4)
      ..write(obj.efactor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSRSAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordSRS _$WordSRSFromJson(Map<String, dynamic> json) => WordSRS(
      word: json['word'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      repetition: (json['repetition'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      efactor: (json['efactor'] as num?)?.toDouble() ?? 2.5,
    );

Map<String, dynamic> _$WordSRSToJson(WordSRS instance) => <String, dynamic>{
      'word': instance.word,
      'dueDate': instance.dueDate.toIso8601String(),
      'repetition': instance.repetition,
      'interval': instance.interval,
      'efactor': instance.efactor,
    };
