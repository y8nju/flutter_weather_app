import 'package:geolocator/geolocator.dart';

class GetLocation {
  late Position myCurrentPosition;

  Future<void> getMyCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      myCurrentPosition = position;
    } catch (e) {
      print('Error message: $e');
    }
  }
}
