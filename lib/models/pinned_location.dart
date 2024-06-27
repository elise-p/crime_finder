import 'package:hive/hive.dart';

part 'pinned_location.g.dart';

@HiveType(typeId: 1)
class PinnedLocation extends HiveObject {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String name;

  // Constructor for PinnedLocation class
  PinnedLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
  });
}
