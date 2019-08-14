import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:seclot/providers/AppStateProvider.dart';

Future getLocation(BuildContext context, AppStateProvider appState,
    Function() onFailureCallback) async {
  /* Future.delayed(Duration(seconds: 4), () {
      appState.setLocation(latitude: 9.0820, longitude: 8.6753);
    });*/
  print("getting location");
  LocationData currentLocation;

  var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
  try {
    print("in get location");
    Future.delayed(Duration(seconds: 5), () => onFailureCallback());

    currentLocation = await location.getLocation();
    print("location set");
    appState.setLocation(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
  } on PlatformException catch (e) {
    print("error getting location");
    if (e.code == 'PERMISSION_DENIED') {}
    currentLocation = null;
  }
}
