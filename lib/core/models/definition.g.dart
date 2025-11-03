// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DefinitionAdapter extends TypeAdapter<Definition> {
  @override
  final int typeId = 6;

  @override
  Definition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Definition(
      partOfSpeech: fields[0] as String?,
      meaning: fields[1] as String?,
      example: fields[2] as String?,
      frequency: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Definition obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.partOfSpeech)
      ..writeByte(1)
      ..write(obj.meaning)
      ..writeByte(2)
      ..write(obj.example)
      ..writeByte(3)
      ..write(obj.frequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefinitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Definition _$DefinitionFromJson(Map<String, dynamic> json) => Definition(
      partOfSpeech: json['partOfSpeech'] as String?,
      meaning: json['meaning'] as String?,
      example: json['example'] as String?,
      frequency: json['frequency'] as String?,
    );

Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
    <String, dynamic>{
      'partOfSpeech': instance.partOfSpeech,
      'meaning': instance.meaning,
      'example': instance.example,
      'frequency': instance.frequency,
    };
