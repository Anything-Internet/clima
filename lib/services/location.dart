import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// This module is a wrapper around the Geolocator package.  It provides
// a Location class that can be used to get the current location.  The
// Location class has a notify function that can be set to a function
// that will be called when the location is updated.  The notify function
// is called whenever the position property is set.

class Location {
  Position? _position;
  LocationPermission? permission;
  late Function? notify;
  List<Placemark> placeMarks = [];
  double? longitude;
  double? latitude;
  String? _cityState;

  // getter / setter for position
  Position? get position {
    return _position;
  }

  String? get cityState {
    return _cityState;
  }

  set cityState(String? cityState) {
    _cityState = cityState;
  }

  set position(Position? position) {
    _position = position!;
    longitude = position.longitude;
    latitude = position.latitude;

    // // override default to my location
    if(longitude == -122.08395287867832 && latitude == 37.42342342342342) {
      longitude = -95.5333662;
      latitude = 29.7141684;
      print("Adjusted Location: $longitude, $latitude");
    }
  }

  ///////////////////////////////////////////////////////
  // main functions - get current location and permission

  Future<void> getCurrentLocation({notify}) async {

    this.notify = notify;

    if (permission == null) {
      await getPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permission access denied");
      return;
    }

    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      if(longitude != null && latitude != null) {
        placeMarks = await placemarkFromCoordinates(latitude!, longitude!);
        cityState = "${placeMarks[0].locality}, ${placeMarks[0].administrativeArea}";
      }
    } catch (e) {
      print(e);
    }
    finally {
      if (notify != null) {
        notify!();
      }
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
