import 'package:crime_finder/models/location.dart';
import 'package:crime_finder/providers/position_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/locations_db.dart';

// A StatefulWidget for displaying a map view.
class MapView extends StatefulWidget {
  final PositionProvider positionProvider;
  final LocationsDB locations;

  const MapView({super.key, required this.positionProvider, required this.locations});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  initState(){
    super.initState();
    widget.positionProvider.updatePosition();
  }

  @override
  dispose() {
    super.dispose();
  }

  // Build method for the flutter google map view
  @override
  Widget build(BuildContext context) {
    return Consumer<PositionProvider>(
      builder: (context, positionProvider, child) {
        if (positionProvider.positionKnown == true) {
          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(positionProvider.latitude??0, positionProvider.longitude??0),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
              MarkerLayer(
                markers: createMarkers(latitude: positionProvider.latitude ?? 0, longitude: positionProvider.longitude ?? 0)
              ),
            ],
          );
        }
        else {
          return Container (
            padding: const EdgeInsets.all(10),
            child: const Text('Please wait for location to load...',
              style: TextStyle(fontSize: 20)),
          );
        }
      },
    );
  }

  // Creates markers on the map based on the nearest locations to the provided latitude and longitude.
  // In this map view, the crime locations are shown as red markers, whereas the user is shown as a black marker.
  List<Marker> createMarkers({required double latitude, required double longitude}) {
    List<Location> locationsList = widget.locations.nearestTo(max: 5, latitude: latitude, longitude: longitude);
    List<Marker> toReturn = locationsList.map((element) {
      return Marker(
        point: LatLng(element.latitude, element.longitude),
        child: const Icon(Icons.location_on, color: Colors.red, size: 30),
      );
    } ).toList();
    toReturn.add(
      Marker(
        point: LatLng(latitude, longitude),
        child: const Icon(Icons.location_history_sharp, color: Colors.black, size: 30),
      ),
    );
    return toReturn;
  }
}
