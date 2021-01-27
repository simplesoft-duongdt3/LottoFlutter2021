// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_manager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSaveInfoAdapter extends TypeAdapter<GameSaveInfo> {
  @override
  final int typeId = 0;

  @override
  GameSaveInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSaveInfo(
      fields[0] as int,
      fields[1] as bool,
      (fields[2] as List)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameSaveInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.finish)
      ..writeByte(2)
      ..write(obj.gotNumbers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSaveInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
