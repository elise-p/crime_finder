// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PinnedLocationAdapter extends TypeAdapter<PinnedLocation> {
  @override
  final int typeId = 1;

  @override
  PinnedLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PinnedLocation(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PinnedLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinnedLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
