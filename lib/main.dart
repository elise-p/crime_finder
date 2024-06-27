import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crime_finder/models/location.dart' as loc;
import 'package:crime_finder/models/pinned_location.dart';
import 'package:crime_finder/models/locations_db.dart';
import 'package:crime_finder/providers/position_provider.dart';
import 'package:crime_finder/views/crime_finder_app.dart';

Future<LocationsDB> loadLocationsDB(String dataPath) async {
  final jsonString = await rootBundle.loadString(dataPath);
  return LocationsDB.initializeFromJson(jsonString);
}

// Initialize Hive for Flutter and register the adapter for the crime location and pinned location
Future<void> initializeHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(loc.LocationAdapter());
  Hive.registerAdapter(PinnedLocationAdapter());
}

// Store the generated encryption key in secure storage.
// Retrieves encryption key and open a Hive box for storing objects with encryption enabled.
Future<void> generateAndStoreEncryptionKey() async {
  const secureStorage = FlutterSecureStorage();
  String? encryptionKeyString = await secureStorage.read(key: 'key');
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey();
    encryptionKeyString = base64UrlEncode(key);
    await secureStorage.write(key: 'key', value: encryptionKeyString);
  }
}

// Open Hive boxes for crime locations and pinned locations with encryption
Future<void> openHiveBoxes() async {
  final encryptionKeyString = await const FlutterSecureStorage().read(key: 'key');
  final encryptionKeyUint8List = base64Url.decode(encryptionKeyString!);
  await Hive.openBox<loc.Location>('locationsBox', encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
  await Hive.openBox<PinnedLocation>('pinnedLocationsBox', encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();
  await generateAndStoreEncryptionKey();
  await openHiveBoxes();

  // Define the path to the JSON file containing location data
  const dataPath = 'assets/location.json';
  try {
    final locations = await loadLocationsDB(dataPath);
    runApp(
      ChangeNotifierProvider(
        create: (context) => PositionProvider(),
        child: CrimeFinderApp(locations: locations),
      ),
    );
    SemanticsBinding.instance.ensureSemantics();
  } catch (error) {
    //print('Error during initialization: $error');
  }
}
