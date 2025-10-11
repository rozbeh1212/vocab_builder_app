// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phrasal_verb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhrasalVerbAdapter extends TypeAdapter<PhrasalVerb> {
  @override
  final int typeId = 4;

  @override
  PhrasalVerb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhrasalVerb(
      phrasalVerb: fields[0] as String,
      meaning: fields[1] as String,
      example: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhrasalVerb obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.phrasalVerb)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.example);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhrasalVerbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhrasalVerb _$PhrasalVerbFromJson(Map<String, dynamic> json) => PhrasalVerb(
      phrasalVerb: json['phrasalVerb'] as String,
      meaning: json['meaning'] as String,
      example: json['example'] as String,
    );

Map<String, dynamic> _$PhrasalVerbToJson(PhrasalVerb instance) =>
    <String, dynamic>{
      'phrasalVerb': instance.phrasalVerb,
      'meaning': instance.meaning,
      'example': instance.example,
    };
