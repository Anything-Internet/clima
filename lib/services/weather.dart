import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Weather {

  Function? notify;

  String? weatherData;
  double? latitude;
  double? longitude;
  int? weatherDateTimeStamp;
  String? weatherDateTimeString;
  double? weatherTempImperial;
  double? weatherTempFeelsLikeImperial;
  double? weatherHumidity;
  double? weatherClouds;
  String? weatherMain;

  getWeatherData(
      {required double lat, required double lon, Function? notify}) async {
    latitude = lat;
    longitude = lon;
    Response response = Response("", 404);
    String apiKey = "78f8acfe89ef6139f0e580e221a12a90";
    String units =
        "imperial"; // "metric" for celsius, "imperial" for fahrenheit
    String url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&units=$units&appid=$apiKey";

    print("Getting weather data from $url");
    try {
      response = await get(Uri.parse(url));
    } catch (e) {
      print(e);
    } finally {
      if (response.statusCode != 200) {
        print("Error: ${response.statusCode}");
        return;
      }

      weatherData = await response.body;

      parseWeatherData(weatherData);


      if (notify != null) {
        notify();
      }
    }
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

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  void parseWeatherData(weatherData) {
    weatherDateTimeStamp = jsonDecode(weatherData)["current"]["dt"] * 1000000;
    weatherDateTimeString = DateFormat.yMd()
        .add_jm()
        .format(DateTime.fromMicrosecondsSinceEpoch(weatherDateTimeStamp!));
    weatherTempImperial = jsonDecode(weatherData)["current"]["temp"].toDouble();
    weatherTempFeelsLikeImperial =
    jsonDecode(weatherData)["current"]["feels_like"].toDouble();
    weatherHumidity = jsonDecode(weatherData)["current"]["humidity"].toDouble();
    weatherMain = jsonDecode(weatherData)["current"]["weather"][0]["main"];
    weatherClouds = jsonDecode(weatherData)["current"]["clouds"].toDouble();



    print("WeatherTime: ${weatherDateTimeString ?? "No data"}");
    print("WeatherMain: ${weatherMain ?? "No data"}");
    print("WeatherTemp: ${weatherTempImperial ?? "No data"}");
    print("WeatherFeelsLike: ${weatherTempFeelsLikeImperial ?? "No data"}");
    print("WeatherHumidity: ${weatherHumidity ?? "No data"}");
    print("WeatherClouds: ${weatherClouds ?? "No data"}");
  }
}
