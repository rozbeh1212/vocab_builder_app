// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_collocation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommonCollocationAdapter extends TypeAdapter<CommonCollocation> {
  @override
  final int typeId = 5;

  @override
  CommonCollocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommonCollocation(
      type: fields[0] as String,
      collocation: fields[1] as String,
      example: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CommonCollocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.collocation)
      ..writeByte(2)
      ..write(obj.example);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonCollocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonCollocation _$CommonCollocationFromJson(Map<String, dynamic> json) =>
    CommonCollocation(
      type: json['type'] as String,
      collocation: json['collocation'] as String,
      example: json['example'] as String,
    );

Map<String, dynamic> _$CommonCollocationToJson(CommonCollocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'collocation': instance.collocation,
      'example': instance.example,
    };
