import 'package:flutter/material.dart';
import 'package:fluxweather/services/location.dart';
import 'package:fluxweather/services/networking.dart';

const apiKey = '3cf223f42c3ca5d01eb16f70e29b519b';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  BuildContext? context;
  Future<dynamic> getLocationWeather(BuildContext mContext) async {
    Location location = Location(buildContext: mContext);
    await location.getLocation(); //get the current location
    // latitude = location.getLatitude();
    // longitude = location.getLongitude();
    // print(latitude);
    // print(longitude);
    NetworkHelper networkHelper = NetworkHelper(
        url:
            '$openWeatherMapURL?lat=${location.getLatitude()}&lon=${location.getLongitude()}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    /*int and doule extend num, use it to avoid errors.
      The data returned is sometimes in double and sometimes in int
       */
    return weatherData;
  }

  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url: url);
    var weatherData = await networkHelper.getData();
    return weatherData;
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
}
