import 'package:flutter/material.dart';
import 'package:fluxweather/utilities/constants.dart';
import 'package:fluxweather/services//weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({required this.locationWeather});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  /*
  Set the data type as dynamic because
  the data coming is of type var
   */
  int? temperature;
  int? condition;
  String? weatherIcon;
  String? weatherMessage;
  String? cityName;
  WeatherModel weatherModel = WeatherModel();
  void updateUI({dynamic weatherData}) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        condition = 0;
        cityName = '';
        weatherIcon = 'Error!';
        weatherMessage = 'Unable to get weather data';
        return;
      }

      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      weatherIcon = weatherModel.getWeatherIcon(condition ?? 0);
      weatherMessage = weatherModel.getMessage(temperature ?? 0);
      weatherMessage = '$weatherMessage in $cityName';
    });
    /* Wrap the content in setState() to make the widgets
    listen to the updates
     */
  }

  @override
  void initState() {
    print('Enterd the _LocationScreenState initState() method!');
    super.initState();
    /*
    We get access to the widget object inside every single
    state object. We get access to the LocationScreen stateful widget using
    this widget object
     */
    print(widget);
    //print(widget.locationWeather); //we get the data from the widget object
    updateUI(weatherData: widget.locationWeather);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/location_background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        )),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var weatherData =
                          await weatherModel.getLocationWeather(context);
                      updateUI(weatherData: weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      /*The push method can also be used
                      to get the data from the screen it leads to
                      using the future
                      Therefore create it a variable
                      Remember this will be an asynchronous method beacause the
                      user has to send that data
                       */
                      var cityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      print('City name received: $cityName');
                      if (cityName != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(cityName);
                        updateUI(weatherData: weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon ?? '!',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  weatherMessage ?? '!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
