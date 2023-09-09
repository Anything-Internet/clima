import 'dart:io';
import 'package:geolocator/geolocator.dart';

class Location {
  Position? _position;
  LocationPermission? permission;
  late Function? notify;

  Position? get position {
    return _position;
  }

  set position(Position? position) {
    _position = position;
    if (notify != null) {
      notify!();
    }
  }

  Location({ Function? notify }) {
    this.notify = notify;
    getCurrentLocation();
  }

  Future<void> getPermission() async {
    if (permission == null) {
      try {
        permission = await Geolocator.requestPermission();
      } catch (e) {
        permission = null;
        print(e);
        return;
      }
    }
  }

  Future<void> getCurrentLocation() async {
    if (permission == null) {
      await getPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permission denied");
      return;
    }

    // simulate a long running operation
    // sleep(Duration(seconds: 5));

    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }
    finally {
      if (notify != null) {
        notify!();
      }
      print(position);
    }
  }
}
