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

  Weather({
    this.notify,
    this.cityState,
    this.longitude,
    this.latitude}) {
    loadData();
  }

  loadData() async {

    if(cityState != null) {
      // get longitude, latitude from cityState
      await location.findLongitudeLatitude(cityState!);
      latitude = location.latitude;
      longitude = location.longitude;
    }

    if(longitude == null || latitude == null) {
      // get current longitude, latitude and cityState
      await getCurrentLocation();
    } else {
      // get cityState from longitude, latitude
      await getCityState(longitude: longitude, latitude: latitude);
    }
    getWeatherData();
  }

  getCityState({latitude, longitude}) async {
    cityState = await location.findCityState(longitude, latitude);
  }

  getCurrentLocation() async {
    await location.findCurrentLocation();
    longitude = location.longitude;
    latitude = location.latitude;
    cityState = location.cityState;
  }

  getWeatherData () async {
    String? apiKey = dotenv.env['WEATHER_API_KEY'];
    String units = "imperial"; // "metric" "imperial" "standard"
    String url = "https://api.openweathermap.org/data/3.0/onecall?"
        "lat=$latitude"
        "&lon=$longitude"
        "&units=$units"
        "&appid=$apiKey";

    print("Getting weather data from $url");
    weatherData = await NetworkRequester.getWebData(url);

    if (notify != null) {
      notify!();
    }
  }
}
