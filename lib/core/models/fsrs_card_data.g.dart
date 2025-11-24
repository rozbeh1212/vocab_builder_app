// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fsrs_card_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FsrsCardDataAdapter extends TypeAdapter<FsrsCardData> {
  @override
  final int typeId = 100;

  @override
  FsrsCardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FsrsCardData(
      id: fields[0] as String,
      dueDate: fields[1] as DateTime,
      ease: fields[2] as double,
      intervalDays: fields[3] as int,
      repetitions: fields[4] as int,
      difficulty: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FsrsCardData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dueDate)
      ..writeByte(2)
      ..write(obj.ease)
      ..writeByte(3)
      ..write(obj.intervalDays)
      ..writeByte(4)
      ..write(obj.repetitions)
      ..writeByte(5)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsCardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
