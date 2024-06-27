import 'package:crime_finder/models/location.dart';
import 'package:crime_finder/models/locations_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crime_finder/providers/position_provider.dart';
import 'package:crime_finder/models/pinned_location.dart';


class NameView extends StatefulWidget {
  final LocationsDB locations;

  const NameView({super.key, required this.locations});

  @override
  State<NameView> createState() => _NameViewState();
}

// A StatefulWidget for the NameView
class _NameViewState extends State<NameView> {
  late PositionProvider _positionProvider;
  final TextEditingController _locationNameController = TextEditingController();
  Box<PinnedLocation>? _pinnedLocationsBox;

  @override
  void initState() {
    super.initState();
    _positionProvider = Provider.of<PositionProvider>(context, listen: false);
    _positionProvider.updatePosition();
    _openBox();
  }

  // Opens the Hive box for pinned locations
  Future<void> _openBox() async {
    _pinnedLocationsBox =
        await Hive.openBox<PinnedLocation>('pinnedLocationsBox');
    setState(() {
      //print('Box opened: ${_pinnedLocationsBox!.values}');
    });
  }

  // Method used for pinning location, as this is done by accepting latitude and longitude values. 
  void _pinLocation() async {
    final locationName = _locationNameController.text;
    final latitude = _positionProvider.latitude ?? 0;
    final longitude = _positionProvider.longitude ?? 0;

    try {
      final newLocation = PinnedLocation(
        latitude: latitude,
        longitude: longitude,
        name: locationName,
      );
      await _pinnedLocationsBox!.add(newLocation);
      //print('Pinned Location: $newLocation');
      _locationNameController.clear();
    } catch (e) {
      //print('Error pinning location: $e');
    }
    setState(() {});
  }

  // Build method for pin position feature, which checks if the pinned locations box is opened and if so
  // after pinning your location it is able to also show list of the previous current locations you have pinned. 
  // A user can also associate a name to their pinned location, for example home, office, etc. 
  @override
  Widget build(BuildContext context) {
    if (_pinnedLocationsBox != null) {
      return Scaffold(
        appBar: AppBar(
          title: Semantics(
              hint: 'Save Your Location',
              child: const Text('Save Your Location')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                hint: 'Current Location Name',
                child: const Text(
                  'Current Location Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _locationNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter name for current location',
                ),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    minimumSize: WidgetStateProperty.all(const Size(60, 50)),
                  ),
                  onPressed: _pinLocation,
                  child: Semantics(
                      hint: 'Pin',
                      child: const Text('Pin',
                          style: TextStyle(color: Colors.white, fontSize: 14))),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _pinnedLocationsBox!.listenable(),
                  builder: (context, Box<PinnedLocation> box, _) {
                    final pinnedLocations = box.values.toList();
                    return ListView.builder(
                      itemCount: pinnedLocations.length,
                      itemBuilder: (context, index) {
                        final location =
                            pinnedLocations.reversed.toList()[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey,
                          ),
                          margin: const EdgeInsets.all(5),
                          child: ListTile(
                            leading: const Icon(Icons.location_on, color: Color.fromARGB(255, 198, 96, 89)),
                            title: Semantics(
                                hint: location.name,
                                child: Text(location.name, style: const TextStyle(color: Colors.black, fontSize: 20))),
                            subtitle: amountNearby() == 6
                                ? Semantics(
                                    hint: '5+ past crime locations nearby',
                                    child: const Text(
                                        '5+ past crime locations nearby'))
                                : Semantics(
                                    hint:
                                        '${amountNearby()} past crime locations nearby',
                                    child: Text(
                                        '${amountNearby()} past crime locations nearby')),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Semantics(hint: 'Loading', child: const Text('Loading...'));
    }
  }

  // Method used to count the number of nearby crime locations
  int amountNearby() {
    List<Location> allLocations = widget.locations.nearestTo(
        max: 6,
        latitude: _positionProvider.latitude ?? 0,
        longitude: _positionProvider.longitude ?? 0);
    int count = 0;
    int i = 0;
    while (i < allLocations.length) {
      if (allLocations[i].distanceInKilometers(
              latitude: _positionProvider.latitude ?? 0,
              longitude: _positionProvider.longitude ?? 0) <
          2) count++;
      i++;
    }
    return count;
  }
}
