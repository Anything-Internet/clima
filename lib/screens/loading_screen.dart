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
      setState(() {});
      getWeather();
    });
  }

  getWeather() async {
    await weather.getWeatherData(
        lat: location.latitude!,
        lon: location.longitude!,
        notify: () {
          setState(() {});
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
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(
                    color: Colors.indigo[400]!,
                    width: 2,
                  ),
                ),
                onPressed: getLocation,
                child: Text("Refresh")),
          ],
        ),
      ),
    );
  }

  Widget weatherCard() {
    const textStyleNormal = TextStyle(
      fontSize: 26,
    );
    const textStyleLarge = TextStyle(
      fontSize: 70,
    );

    return Container(
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.indigo[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.indigo[400]!,
          width: 2,
        ),
      ),
      child: weather.weatherData == null
          ? Text(
              "Forecasting ...",
              style: textStyleNormal,
            )
          : Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            weather.weatherIcon ?? "",
            style: textStyleLarge,
          ),
          Text(
            location.cityState ?? "",
            style: textStyleNormal,
          ),
          Text(
            weather.weatherDateTimeString ?? "",
          ),
          SizedBox(
            height: 10,
          ),
          Text(weather.weatherTempImperialString ?? "",
              style: textStyleLarge),
          SizedBox(
            height: 10,
          ),
          Text(
            weather.weatherMessage ?? "",
            style: textStyleNormal,
          ),
        ],
      ),
    );
  }
}
