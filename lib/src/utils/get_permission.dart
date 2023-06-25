import 'package:geolocator/geolocator.dart';

class GetPermission {
  static Future<bool> checkLocationPermission() async {
    try {
      if (await Geolocator.checkPermission() == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkEnableLocation() async {
    try {
      if (await Geolocator.isLocationServiceEnabled()) {
        return true;
      } else {
        Geolocator.openLocationSettings();
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
