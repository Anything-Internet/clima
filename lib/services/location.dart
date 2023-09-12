import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
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

    print("DEVICE Location: $longitude, $latitude");

    // override default Android location to my location
    if (longitude == -122.08395287867832 && latitude == 37.42342342342342) {
      longitude = -95.5333662;
      latitude = 29.7141684;
      print("ADJUSTED Location: $longitude, $latitude");
    }
  }

  bool findLocationEnabled() {
    if (kIsWeb) {
      print("Find location not supported on web.");
      return false;
    }

    if (Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      return true;
    }
    print("Find location not supported on Mac/Linux/Windows.");

    return false;
  }

  findLongitudeLatitude(searchAddress) async {
    List<dynamic> locations;
    if (findLocationEnabled() == false) {
      return;
    }

    try {
      locations = await locationFromAddress(searchAddress);
      longitude = locations[0].longitude;
      latitude = locations[0].latitude;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> findCityState(longitude, latitude) async {
    if (findLocationEnabled() == false) {
      return null;
    }
    try {
      placeMarks = await placemarkFromCoordinates(latitude, longitude);
      cityState =
          "${placeMarks[0].locality} ${placeMarks[0].administrativeArea}"
              .trim();
    } catch (e) {
      print(e);
    }
    return cityState;
  }

  Future<void> findCurrentLocation({notify}) async {
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

      if (longitude != null && latitude != null) {
        cityState = await findCityState(longitude, latitude);
      }
    } catch (e) {
      print(e);
    } finally {
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
