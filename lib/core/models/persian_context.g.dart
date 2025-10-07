// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persian_context.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersianContextAdapter extends TypeAdapter<PersianContext> {
  @override
  final int typeId = 2;

  @override
  PersianContext read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersianContext(
      meaning: fields[0] as String,
      example: fields[1] as String,
      usageNotes: fields[2] as String?,
      collocations: (fields[3] as List).cast<String>(),
      prepositionUsage: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersianContext obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.meaning)
      ..writeByte(1)
      ..write(obj.example)
      ..writeByte(2)
      ..write(obj.usageNotes)
      ..writeByte(3)
      ..write(obj.collocations)
      ..writeByte(4)
      ..write(obj.prepositionUsage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersianContextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersianContext _$PersianContextFromJson(Map<String, dynamic> json) =>
    PersianContext(
      meaning: json['meaning'] as String,
      example: json['example'] as String,
      usageNotes: json['usageNotes'] as String?,
      collocations: (json['collocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      prepositionUsage: json['prepositionUsage'] as String?,
    );

Map<String, dynamic> _$PersianContextToJson(PersianContext instance) =>
    <String, dynamic>{
      'meaning': instance.meaning,
      'example': instance.example,
      'usageNotes': instance.usageNotes,
      'collocations': instance.collocations,
      'prepositionUsage': instance.prepositionUsage,
    };
