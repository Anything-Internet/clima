import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
   Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                  getLocation();

                //Get the current location
              },
              child: Text('Get Location'),
            ),
            Text(position?.toString() ?? ''),
          ],
        ),
      ),
    );
  }

  Future<void> getLocation() async {

    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    print(permission);

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    setState(() {
      this.position = position;
    });

    print(position);
  }
}
