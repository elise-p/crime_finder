import 'dart:async';
import 'package:crime_finder/models/locations_db.dart';
import 'package:crime_finder/providers/position_provider.dart';
import 'package:crime_finder/views/crime_list_view.dart';
import 'package:crime_finder/views/map_view.dart';
import 'package:crime_finder/views/pin_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<LocationsDB> loadLocationsDB(String dataPath) async {
  return LocationsDB.initializeFromJson(await rootBundle.loadString(dataPath));
}

// A StatefulWidget for displaying basic view for our crime finder app.
class CrimeFinderApp extends StatefulWidget {
  final LocationsDB locations;

  const CrimeFinderApp({super.key, required this.locations});

  @override
  State<CrimeFinderApp> createState() => _CrimeFinderAppState();
}

class _CrimeFinderAppState extends State<CrimeFinderApp> {
  late final Timer _checkerTimer;
  late final PositionProvider _positionProvider;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _positionProvider = Provider.of<PositionProvider>(context, listen: false);


    // Based on the timer, every second the updatePosition method is called. 
    _checkerTimer = Timer.periodic(const Duration(seconds: 1),
        (timer) => _positionProvider.updatePosition());
    _positionProvider.updatePosition();
  }

  // Timer cancels when widget is not of use. 
  @override
  void dispose() {
    _checkerTimer.cancel();
    super.dispose();
  }

  // Build method for creating the app bar at the top of the app and the navigation bar view at the bottom of the app.  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Consumer<PositionProvider>(
            builder: (context, positionProvider, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.red,
                  title: Center(
                    child: Semantics(
                      hint: 'Crime Finder',
                      child: const Text(
                        'Crime Finder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: NavigationBarTheme(
                  data: NavigationBarThemeData(
                      labelTextStyle: WidgetStateProperty.all(
                        const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      )
                    ),
                  child: NavigationBar(
                    height: 100,
                    backgroundColor: Colors.black,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                    indicatorColor: Colors.red,
                    selectedIndex: _currentTabIndex,
                    destinations: <Widget>[
                      Semantics(
                          hint: 'Map',
                          child: const NavigationDestination(
                              icon: Icon(Icons.map, color: Colors.white),
                              label: 'Map')),
                      Semantics(
                          hint: 'Crime List',
                          child: const NavigationDestination(
                              icon: Icon(Icons.list, color: Colors.white),
                              label: 'Crime List')),
                      Semantics(
                          hint: 'Pinned Locations',
                          child: const NavigationDestination(
                              icon: Icon(Icons.edit_location_sharp,
                                  color: Colors.white),
                              label: 'Pinned Locations')),
                    ],
                  ),
                ),
                body: Center(
                  child: _currentTabIndex == 0
                      ? MapView(
                          positionProvider: positionProvider,
                          locations: widget.locations)
                      : _currentTabIndex == 1
                          ? CrimeList(
                              userLatitude: positionProvider.latitude,
                              userLongitude: positionProvider.longitude,
                            )
                          : NameView(locations: widget.locations),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
