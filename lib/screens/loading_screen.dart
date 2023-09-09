import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Location location;
  late Weather weather = Weather();

  @override
  void initState() {
    super.initState();
    location = Location(notify: () {
      setState(() {
        weather.getWeatherData(
            lat: location.latitude!,
            lon: location.longitude!,
            notify: () {
              setState(() {});
            });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Lat: ${location.latitude?.toString() ?? 'waiting ...'}"),
            // Text("Lon: ${location.longitude?.toString() ?? 'waiting ...'}"),
            weather.weatherData == null ? CircularProgressIndicator() :
            Text(""
                "${weather.weatherTempImperial ?? ""} - "
                "${weather.weatherMain ?? "waiting ..."}"),
          ],
        ),
      ),
    );
  }
}

