import 'package:intl/intl.dart';

class WeatherData {
  var weatherData;
  String? cityState;

  WeatherData({this.weatherData, this.cityState});

  // everything below here is getters, with formatting if needed

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
  double? get moonPhase {
    // 0.0 - New moon
    // 0.125 - Waxing crescent
    // 0.25 - First quarter
    // 0.375 - Waxing gibbous
    // 0.5 - Full moon
    // 0.625 - Waning gibbous
    // 0.75 - Last quarter
    // 0.875 - Waning crescent
    // 1.0 - New moon

    return weatherData == null
        ? null
        : weatherData["daily"][0]["moon_phase"].toDouble();
  }
}
