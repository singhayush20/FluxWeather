import 'package:flutter/material.dart';
import 'package:fluxweather/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluxweather/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    print('initState() called');
    getLocationData();
  }

  void getLocationData() async {
    WeatherModel weatherModel = WeatherModel();
    var weatherData = await weatherModel.getLocationWeather(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(locationWeather: weatherData);
        },
      ),
      ModalRoute.withName("/Home"),
    );
    
    print('leaving getLocation()');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 50.0,
        
        ),
      ),
    );
  }
}
