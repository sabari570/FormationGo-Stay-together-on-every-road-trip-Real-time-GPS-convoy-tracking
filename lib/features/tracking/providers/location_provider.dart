import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
Stream<Position> locationStream(LocationStreamRef ref) async* {
  // 1. Check if the device location service is enabled
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled. Please enable GPS.');
  }

  // 2. Check / request permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied. Please allow location access.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permission permanently denied. '
      'Please enable it from app settings.',
    );
  }

  // 3. All good — start streaming positions
  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );
}
