// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preposition_usage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrepositionUsageAdapter extends TypeAdapter<PrepositionUsage> {
  @override
  final int typeId = 3;

  @override
  PrepositionUsage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrepositionUsage(
      preposition: fields[0] as String?,
      usagePattern: fields[1] as String?,
      meaning: fields[2] as String?,
      example: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrepositionUsage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.preposition)
      ..writeByte(1)
      ..write(obj.usagePattern)
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
      other is PrepositionUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrepositionUsage _$PrepositionUsageFromJson(Map<String, dynamic> json) =>
    PrepositionUsage(
      preposition: json['preposition'] as String?,
      usagePattern: json['usagePattern'] as String?,
      meaning: json['meaning'] as String?,
      example: json['example'] as String?,
    );

Map<String, dynamic> _$PrepositionUsageToJson(PrepositionUsage instance) =>
    <String, dynamic>{
      'preposition': instance.preposition,
      'usagePattern': instance.usagePattern,
      'meaning': instance.meaning,
      'example': instance.example,
    };
