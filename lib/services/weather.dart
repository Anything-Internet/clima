import 'package:clima/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class Weather {
  Function? notify;
  dynamic weatherData;
  double? latitude;
  double? longitude;

  int? get weatherDateTimeStamp {
    return weatherData == null ? null : weatherData["current"]["dt"] * 1000000;
  }

  String? get weatherDateTimeString {
    return weatherData == null
        ? null
        : DateFormat.yMd()
            .add_jm()
            .format(DateTime.fromMicrosecondsSinceEpoch(weatherDateTimeStamp!));
  }

  double? get weatherTempImperial {
    return weatherData == null
        ? null
        : weatherData["current"]["temp"].toDouble();
  }

  String? get weatherTempImperialString {
    return weatherTempImperial == null
        ? null
        : "${weatherTempImperial?.round().toString()}°";
  }

  double? get weatherTempFeelsLikeImperial {
    return weatherData == null
        ? null
        : weatherData["current"]["feels_like"].toDouble();
  }

  double? get weatherHumidity {
    return weatherData == null
        ? null
        : weatherData["current"]["humidity"].toDouble();
  }

  double? get weatherClouds {
    return weatherData == null
        ? null
        : weatherData["current"]["clouds"].toDouble();
  }

  String? get weatherDescription {
    return weatherData == null
        ? null
        : weatherData["current"]["weather"][0]["description"];
  }

  String? get weatherMain {
    return weatherData == null
        ? null
        : weatherData["current"]["weather"][0]["main"];
  }

  int? get weatherConditionCode {
    return weatherData == null
        ? null
        : weatherData["current"]["weather"][0]["id"]!.toInt();
  }

  get weatherIcon {
    return weatherConditionCode == null
        ? null
        : getWeatherIcon(weatherConditionCode!);
  }

  get weatherMessage {
    return weatherTempImperial == null
        ? null
        : getMessage(weatherTempImperial!);
  }

  getWeatherData (
      {required double lat, required double lon, Function? notify}) async {
    latitude = lat;
    longitude = lon;

    String? apiKey = dotenv.env['WEATHER_API_KEY'];
    String units = "imperial"; // "metric" "imperial" "standard"
    String url = "https://api.openweathermap.org/data/3.0/onecall?"
        "lat=$lat"
        "&lon=$lon"
        "&units=$units"
        "&appid=$apiKey";

    print("Getting weather data from $url");
    weatherData = await NetworkRequester.get(url);

    if (notify != null) {
      notify();
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

  String getMessage(double temp) {
    if (temp > 90) {
      return 'It\'s 🍦 time';
    } else if (temp > 75) {
      return 'Time for 🩳 and 👕';
    } else if (temp < 60) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
