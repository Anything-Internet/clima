import 'package:clima/services/networking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'location.dart';

class Weather {
  Function? notify;
  dynamic weatherData;
  double? latitude;
  double? longitude;
  String? cityState;
  Location location = Location();

  Weather({this.notify}){
    getLocation();
  }

  getLocation() async {
    await location.getCurrentLocation();
    longitude = location.longitude;
    latitude = location.latitude;
    cityState = location.cityState;
    getWeatherData(lat: latitude!, lon: longitude!);
  }

  getWeatherData (
      {required double lat, required double lon}) async {
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
    weatherData = await NetworkRequester.getWebData(url);

    if (notify != null) {
      notify!();
    }
  }
}
