import 'dart:convert';

import 'package:crime_finder/models/location.dart';


class LocationsDB{
  final List<Location> _locations;

  List<Location> get all{
    return List<Location>.from(_locations, growable: false);
  }

  // Finds the nearest venues, by calculating distance based on coordinates and the sorting crime list, closest to furthest in distance.  
  // Parameters:
  //  - max: The maximum number of venues to return, set to 999.
  //  - latitude: The latitude of the user location.
  //  - longitude: The longitude of the user location.
  // Returns:
  //  A list of crime locations sorted by distance from the target location, with a max of 999
  List<Location> nearestTo({int max = 999, required double latitude, required double longitude}) {
    List<Location> toReturn = _locations;
    toReturn.sort((a, b) => a.distanceFrom(latitude: latitude, longitude: longitude).compareTo(b.distanceFrom(latitude: latitude, longitude: longitude)));
    toReturn.take(max);
    return toReturn;
  } 

  LocationsDB.initializeFromJson(String jsonString) : _locations = _decodeLocationListJson(jsonString);

  static List<Location> _decodeLocationListJson(String jsonString){
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map( (element) {
      return Location.fromJson(element);
    }).toList();
    return theList;
  }

}
