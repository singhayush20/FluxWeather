import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

/*
    If we don't have the await keyword, then we could still have a position
    but it won't be an actual position. It will a Future<Position> which will have a value once the
    action is complete.
    print(position) will print the following line-
    flutter: 'Instance of 'Future<Position>'
    This is like just coming back with just
    a receipt without food.
    That's why we assign the await keyword to wait before the value is assigned to the
    position variable.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy
            .low);
     */
class Location {
  BuildContext buildContext;
  Location({required this.buildContext});
  double? _latitude;
  double? _longitude;
  late bool serviceEnabled;
  late LocationPermission permission;
  Future<void> getLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      try {
        if (permission == LocationPermission.denied) {
          throw ('Permission is denied!');
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
          content: Text("Please grant location!"),
        ));
      }
      try {
        if (permission == LocationPermission.deniedForever) {
          throw ('Location denied forever');
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
          content: Text(
              "Location permission not granted! Data will not be available"),
        ));
      }
    }
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy
              .low); //more accurate the location, more will be the battery usage
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
        content: Text("Location data not available!"),
      ));
      print(e);
    }
    print(position ?? 'Position not found!');
  }

  double getLatitude() {
    return _latitude ?? 0.0;
  }

  double getLongitude() {
    return _longitude ?? 0.0;
  }
}
