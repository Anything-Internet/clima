import 'package:geolocator/geolocator.dart';

// This module is a wrapper around the Geolocator package.  It provides
// a Location class that can be used to get the current location.  The
// Location class has a notify function that can be set to a function
// that will be called when the location is updated.  The notify function
// is called whenever the position property is set.  Permissions are requested
// when the Location class is instantiated.

// Normal usage is to instantiate a Location object in the initState function
// of the widget that needs the location.  The notify function is set to a
// function that calls setState.  The position property is used to get the
// current location.

class Location {
  Position? _position;
  LocationPermission? permission;
  late Function? notify;

  // getter / setter for position
  Position? get position {
    return _position;
  }

  set position(Position? position) {
    _position = position;
    if (notify != null) {
      notify!();
    }
  }

  // constructor - get permission and current location
  Location({ Function? notify }) {
    this.notify = notify;
    getCurrentLocation();
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

    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }
    finally {
      print(position);
    }
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
}
