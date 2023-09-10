import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Location location = Location();
  Weather weather = Weather();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    await location.getCurrentLocation(notify: () {
      setState(() {
        print("location updated");
      });
      getWeather();
    });
  }

  getWeather() async {
    await weather.getWeatherData(
        lat: location.latitude!,
        lon: location.longitude!,
        notify: () {
          setState(() {
            print("weather updated");
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            weatherCard(),
          ],
        ),
      ),
    );
  }

  Widget weatherCard() {
    const textStyleNormal = TextStyle(
        fontSize: 20);
    const textStyleLarge = TextStyle(
        fontSize: 70,
    );

    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,

        children: [
          Text(
            weather.weatherIcon != null
                ? weather.weatherIcon!
                : "Loading...",
            style: textStyleLarge,
          ),
          Text(
            location.cityState != "" ? location.cityState : "unknown",
            style: textStyleNormal,
          ),
          weather.weatherTempImperial == null
              ? CircularProgressIndicator()
              : Text("${weather.weatherTempImperial?.round().toString()}°",
                  style: textStyleLarge),
          Text(
            weather.weatherMessage != null ? weather.weatherMessage : "unknown",
            style: textStyleNormal,
          ),
        ],
      ),
    );
  }
}
