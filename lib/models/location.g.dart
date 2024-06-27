// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 0;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      report_number: fields[0] as String,
      offense_id: fields[1] as String,
      offense_start_datetime: fields[2] as String,
      date: fields[3] as DateTime,
      group_a_b: fields[4] as String,
      crime_against_category: fields[5] as String,
      offense_parent_group: fields[6] as String,
      offense: fields[7] as String,
      offense_code: fields[8] as String,
      precinct: fields[9] as String,
      sector: fields[10] as String,
      beat: fields[11] as String,
      mcpp: fields[12] as String,
      longitude: fields[13] as double,
      latitude: fields[14] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.report_number)
      ..writeByte(1)
      ..write(obj.offense_id)
      ..writeByte(2)
      ..write(obj.offense_start_datetime)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.group_a_b)
      ..writeByte(5)
      ..write(obj.crime_against_category)
      ..writeByte(6)
      ..write(obj.offense_parent_group)
      ..writeByte(7)
      ..write(obj.offense)
      ..writeByte(8)
      ..write(obj.offense_code)
      ..writeByte(9)
      ..write(obj.precinct)
      ..writeByte(10)
      ..write(obj.sector)
      ..writeByte(11)
      ..write(obj.beat)
      ..writeByte(12)
      ..write(obj.mcpp)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.latitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      report_number: json['report_number'] as String,
      offense_id: json['offense_id'] as String,
      offense_start_datetime: json['offense_start_datetime'] as String,
      date: _dateTimeFromJson(json['report_datetime'] as String),
      group_a_b: json['group_a_b'] as String,
      crime_against_category: json['crime_against_category'] as String,
      offense_parent_group: json['offense_parent_group'] as String,
      offense: json['offense'] as String,
      offense_code: json['offense_code'] as String,
      precinct: json['precinct'] as String,
      sector: json['sector'] as String,
      beat: json['beat'] as String,
      mcpp: json['mcpp'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'report_number': instance.report_number,
      'offense_id': instance.offense_id,
      'offense_start_datetime': instance.offense_start_datetime,
      'report_datetime': instance.date.toIso8601String(),
      'group_a_b': instance.group_a_b,
      'crime_against_category': instance.crime_against_category,
      'offense_parent_group': instance.offense_parent_group,
      'offense': instance.offense,
      'offense_code': instance.offense_code,
      'precinct': instance.precinct,
      'sector': instance.sector,
      'beat': instance.beat,
      'mcpp': instance.mcpp,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
