import 'package:clima/models/weather_data.dart';
import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'location_screen.dart';

class LoadingScreen extends StatefulWidget {
  final double? longitude;
  final double? latitude;

  LoadingScreen({Key? key, this.longitude, this.latitude}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Weather weather;
  late WeatherData weatherData;
  late BuildContext context;

  @override
  void initState() {
    super.initState();
    if (widget.longitude != null && widget.latitude != null) {
      weather = Weather(
          longitude: widget.longitude,
          latitude: widget.latitude,
          notify: () => callback());
    } else {
      weather = Weather(notify: () => callback());
    }
  }

  callback() {
    weatherData = WeatherData(
        weatherData: weather.weatherData, cityState: weather.cityState);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        weatherData: weatherData,
        cityState: weather.cityState,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    // once weather finishes fetching,
    // it will redirect to the next page.
    this.context = context;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SpinKitDoubleBounce(
              color: Color.fromRGBO(50, 50, 255, 1),
              duration: Duration(milliseconds: 1500),
              size: 150.0,
            ),
          ],
        ),
      ),
    );
  }
}
