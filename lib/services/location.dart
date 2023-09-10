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
  String _cityState = "";

  // getter / setter for position
  Position? get position {
    return _position;
  }

  String get cityState {
    return _cityState;
  }

  set cityState(String cityState) {
    _cityState = cityState;
    print("cityState: $cityState");
  }

  set position(Position? position) {
    _position = position!;
    longitude = position.longitude;
    latitude = position.latitude;

    // // override to my location
    latitude = 29.7141684;
    longitude = -95.5333662;

    print("longitude: $longitude");
    print("latitude: $latitude");
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
      print("Permission denied");
      return;
    }

    // test code to simulate a delay
    // sleep(Duration(seconds: 5));

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
        print("notify");
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
