// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

part 'location.g.dart';

DateTime _dateTimeFromJson(String date) => DateTime.parse(date);

@JsonSerializable()
@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(0)
  final String report_number;

  @HiveField(1)
  final String offense_id;

  @HiveField(2)
  final String offense_start_datetime;

  @HiveField(3)
  @JsonKey(name: 'report_datetime', fromJson: _dateTimeFromJson)
  final DateTime date;

  @HiveField(4)
  final String group_a_b;

  @HiveField(5)
  final String crime_against_category;

  @HiveField(6)
  final String offense_parent_group;

  @HiveField(7)
  final String offense;

  @HiveField(8)
  final String offense_code;

  @HiveField(9)
  final String precinct;

  @HiveField(10)
  final String sector;

  @HiveField(11)
  final String beat;

  @HiveField(12)
  final String mcpp;

  @HiveField(13)
  final double longitude;

  @HiveField(14)
  final double latitude;

  // Constructor for Location class
  Location({
    required this.report_number,
    required this.offense_id,
    required this.offense_start_datetime,
    required this.date,
    required this.group_a_b,
    required this.crime_against_category,
    required this.offense_parent_group,
    required this.offense,
    required this.offense_code,
    required this.precinct,
    required this.sector,
    required this.beat,
    required this.mcpp,
    required this.longitude,
    required this.latitude,
  });

  // JSON deserialization factory method
  factory Location.fromJson(Map<String, dynamic> json) {
    try {
      return Location(
        report_number: json['report_number'] ?? '',
        offense_id: json['offense_id'] ?? '',
        offense_start_datetime: json['offense_start_datetime'] ?? '',
        date: _dateTimeFromJson(json['report_datetime'] ?? ''),
        group_a_b: json['group_a_b'] ?? '',
        crime_against_category: json['crime_against_category'] ?? '',
        offense_parent_group: json['offense_parent_group'] ?? '',
        offense: json['offense'] ?? '',
        offense_code: json['offense_code'] ?? '',
        precinct: json['precinct'] ?? '',
        sector: json['sector'] ?? '',
        beat: json['beat'] ?? '',
        mcpp: json['mcpp'] ?? '',
        longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      );
    } catch (e) {
      // If any error occurs during parsing, return a default Location object
      return Location(
        report_number: '',
        offense_id: '',
        offense_start_datetime: '',
        date: DateTime.now(),
        group_a_b: '',
        crime_against_category: '',
        offense_parent_group: '',
        offense: '',
        offense_code: '',
        precinct: '',
        sector: '',
        beat: '',
        mcpp: '',
        longitude: 0.0,
        latitude: 0.0,
      );
    }
  }

  // JSON serialization method
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  // Factory method to create crime location data object from given JSON data
  factory Location.createLocation(Map<String, dynamic> object) {
    return Location(
      report_number: object['report_number'],
      offense_id: object['offense_id'],
      offense_start_datetime: object['offense_start_datetime'],
      date: DateTime.parse(object['report_datetime']),
      group_a_b: object['group_a_b'],
      crime_against_category: object['crime_against_category'],
      offense_parent_group: object['offense_parent_group'],
      offense: object['offense'],
      offense_code: object['offense_code'],
      precinct: object['precinct'],
      sector: object['sector'],
      beat: object['beat'],
      mcpp: object['mcpp'],
      longitude: double.parse(object['longitude']),
      latitude: double.parse(object['latitude']),
    );
  }

  // Uses Pythagorean Theorem to compute the distance between the user and location using latitude and longitude
  // - latitude: The latitude of the user location.
  // - longitude: The longitude of the user location.
  // - this.latitude: The latitude of the crime location.
  // - this.longitude: The longitude of the crime location.
  double distanceFrom({required double latitude, required double longitude}) {
    return sqrt(_squared(latitude - this.latitude) + _squared(longitude - this.longitude));
  }

  // Returns the distance in units of kilometers
  double distanceInKilometers({required double latitude, required double longitude}) {
    return 111139 * distanceFrom(latitude: latitude, longitude: longitude) / 1000;
  }

  // Returns the squared value of the double value
  double _squared(double x) => x * x;


  // Queries and retrieves crime location information from an Seattle Gov API
  static Future<List<Location>> getLocation() async {
    String apiURL = 'https://data.seattle.gov/resource/tazs-3rd5.json';
    var apiResult = await http.get(Uri.parse(apiURL));
    List<dynamic> listLocations = json.decode(apiResult.body) as List<dynamic>;

    return listLocations.map((loc) => Location.createLocation(loc)).toList();
  }
}
