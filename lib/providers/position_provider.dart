import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// A provider class that manages the user's current position.
// - latitude: Latitude of the user's current position.
// - longitude: Longitude of the user's current position.
// - positionKnown: Boolean variable that becomes true if the user's position is known
class PositionProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;
  bool positionKnown = false;
  late final Timer updateTimer;

  PositionProvider() {
    // Initialize the updateTimer and update location every second.
    updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updatePosition();
    });
  }

  @override
  void dispose() {
    // Cancel updateTimer when the PositionProvider is disposed
    updateTimer.cancel();
    super.dispose();
  }

  Future<void> updatePosition() async {
    _determinePosition()
      .then((position) {
        // Update latitude and longitude with the new position, and notify listeners
        latitude = position.latitude;
        longitude = position.longitude;
        positionKnown = true;
        notifyListeners();
      })
      .onError((error, stackTrace) {
        // Handle errors using onError, when determining position and notify listeners
        positionKnown = false;
        notifyListeners();
      });
  }

  // Determine the current position of the device using Geolocator.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }
}
