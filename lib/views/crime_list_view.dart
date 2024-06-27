// ignore_for_file: library_private_types_in_public_api

import 'package:crime_finder/models/location.dart';
import 'package:flutter/material.dart';

// A StatefulWidget for displaying a list of nearby crimes.
class CrimeList extends StatefulWidget {
  final double? userLatitude;
  final double? userLongitude;

  const CrimeList({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  _CrimeListState createState() => _CrimeListState();
}

class _CrimeListState extends State<CrimeList> {
  List<Location> locations = [];

  @override
  void initState() {
    super.initState();
    updateLocations();
  }

  // Updates the list of locations
  void updateLocations() async {
    locations = await Location.getLocation();
    locations.sort((a, b) => a
        .distanceFrom(
          latitude: widget.userLatitude ?? 0.0,
          longitude: widget.userLongitude ?? 0.0,
        )
        .compareTo(
          b.distanceFrom(
            latitude: widget.userLatitude ?? 0.0,
            longitude: widget.userLongitude ?? 0.0,
          ),
        ));
    if(mounted) setState(() {});
  }

  // Calculates the number of days ago from the input date from the location data
  int daysAgo(DateTime inputDate) {
    Duration difference = DateTime.now().difference(inputDate);
    return difference.inDays;
  }

  // Build method for the list view where if the location is less than 1 km, the list item is highlighted in red 
  // else it would remain as white, as this is used to indicate whether the user is nearing the crime location.
  // Each list item contains information such as how many days it was ago and your distance from the crime location.  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Crime')
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var location in locations)
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: location.distanceInKilometers(
                              latitude: widget.userLatitude ?? 0.0,
                              longitude: widget.userLongitude ?? 0.0) <
                          1
                      ? Border.all(color: Colors.red)
                      : null,
                  borderRadius: BorderRadius.circular(8.0),
                  color: location.distanceInKilometers(
                              latitude: widget.userLatitude ?? 0.0,
                              longitude: widget.userLongitude ?? 0.0) <
                          1
                      ? Colors.red.withOpacity(
                          0.3)
                      : null,
                ),
                child: ListTile(
                  title: Semantics( hint: location.offense,child: Text(location.offense, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics( 
                        hint: '${daysAgo(location.date)} days ago',
                        child: Text(
                          '${daysAgo(location.date)} days ago',
                        ),
                      ),
                      Semantics( 
                        hint: 'Distance: ${location.distanceInKilometers(latitude: widget.userLatitude ?? 0.0, longitude: widget.userLongitude ?? 0.0).toStringAsFixed(2)} km',
                        child: Text(
                          '${location.distanceInKilometers(latitude: widget.userLatitude ?? 0.0, longitude: widget.userLongitude ?? 0.0).toStringAsFixed(2)} km away',
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.warning_outlined)
                ),
              ),
          ],
        ),
      ),
    );
  }
}
