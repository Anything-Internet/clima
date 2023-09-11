import 'package:flutter/material.dart';
import 'loading_screen.dart';

class LocationScreen extends StatefulWidget {
  final weatherData;
  final cityState;

  const LocationScreen({
    Key? key,
    this.weatherData,
    this.cityState,
  }) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextStyle textStyleSmall = TextStyle(
    fontSize: 20,
  );
  TextStyle textStyleNormal = TextStyle(
    fontSize: 26,
  );
  TextStyle textStyleLarge = TextStyle(
    fontSize: 70,
  );

  get weatherData {
    return widget.weatherData;
  }

  get weatherMessage {
    return weatherData.weatherTempImperial == null
        ? null
        : getMessage(weatherData.weatherTempImperial!);
  }

  get weatherIcon {
    return weatherData.weatherConditionCode == null
        ? null
        : getWeatherIcon(weatherData.weatherConditionCode!);
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(double temp) {
    String tag = '';

    // if (cityState != null) {
    //   tag = 'in $cityState';
    // }
    if (temp > 90) {
      return 'It\'s 🍦 time $tag';
    } else if (temp > 75) {
      return 'Time for 🩳 and 👕 $tag';
    } else if (temp < 60) {
      return 'You\'ll need 🧣 and 🧤 $tag';
    } else {
      return 'Bring a 🧥 just in case $tag';
    }
  }

  Widget moonPhase() {
    double moonPhase = weatherData.moonPhase ?? 0.0;
    String moonPic;

    if (moonPhase < 0.1) {
      moonPic = 'images/0.000 moon.png';
    } else if (moonPhase < 0.2) {
      moonPic = 'images/0.125 moon.png';
    } else if (moonPhase < 0.3) {
      moonPic = 'images/0.250 moon.png';
    } else if (moonPhase < 0.6) {
      moonPic = 'images/0.500 moon.png';
    } else if (moonPhase < 0.8) {
      moonPic = 'images/0.750 moon.png';
    } else if (moonPhase < 0.9) {
      moonPic = 'images/0.875 moon.png';
    } else {
      moonPic = 'images/1.000 moon.png';
    }

    Widget moon = Image(
      image: AssetImage('$moonPic'),
      height: 70,
    );

    if (weatherData.moonPhase == null) {
      return Text('');
    } else {
      return moon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,

            colorFilter: ColorFilter.matrix(<double>[
              0.2, 0.1, 0.2, 0.0, 0.0, // matrix
              0.2, 0.1, 0.1, 0.1, 0.0,
              0.3, 0.4, 0.2, 0.3, 0.0,
              1, 1, 1, 1, 0,
            ]),

            // colorFilter: ColorFilter.mode(
            //     Colors.white.withOpacity(0.99), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoadingScreen();
                      }));
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 100, 0.70),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.indigo[400]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          weatherIcon ?? "",
                          style: textStyleLarge,
                        ),
                        moonPhase(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      weatherData.cityState ?? "",
                      style: textStyleNormal,
                    ),
                    Text(
                      weatherData.weatherDateTimeString ?? "",
                      style: textStyleSmall,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(weatherData.weatherTempImperialString ?? "",
                        style: textStyleLarge),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.indigo[400]!,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      weatherMessage ?? "",
                      style: textStyleNormal,
                    ),
                  ],
                ),
              ),
              SizedBox.fromSize(
                size: Size(0, 70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
