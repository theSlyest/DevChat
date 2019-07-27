import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:seclot/providers/AppStateProvider.dart';

import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../utils/routes_utils.dart';
import 'home/home.dart';
//import 'package:paystack_sdk/paystack_sdk.dart';

class SplashScreen extends StatelessWidget {
  AppStateProvider appState;

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateProvider>(context);
    Future.delayed(Duration.zero, () => checkLoginDetails(context));

    return Scaffold(
      body: Page(),
    );
  }

  Future checkLoginDetails(BuildContext context) async {
    getLocation();
//    print("appState");

    try {
      LocalStorageHelper helper = LocalStorageHelper();
      var userAndToken = await helper.getUserAndToken();
      appState.token = userAndToken.token;
      appState.user = userAndToken.user;

      if (appState.token.isEmpty || appState.user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutUtils.login, (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen(appState)),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e);

      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutUtils.login, (Route<dynamic> route) => false);
    }

    /*LocalStorageHelper().getLoginDetails().then((details) {
      if (details.isNotEmpty && details.contains("token")) {
        var localStorage = LocalStorageHelper();
        localStorage.getPhon().then((phone) {
          localStorage.getPin().then((pin) {
            if (phone.isNotEmpty && pin.isNotEmpty) {
              APIService().performLogin(phone, pin, true).then((result) {
                if (result.isEmpty) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RoutUtils.home, (Route<dynamic> route) => false);
                } else {
                  setState(() {
                    error = true;
                  });
                }
              }).catchError((error) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutUtils.login, (Route<dynamic> route) => false);
              });
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutUtils.login, (Route<dynamic> route) => false);
            }
          });
        });
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutUtils.login, (Route<dynamic> route) => false);
      }
    });*/
  }

  Future getLocation() async {
    Future.delayed(Duration(seconds: 4), () {
      appState.setLocation(latitude: 9.0820, longitude: 8.6753);
    });
    print("getting location");
    LocationData currentLocation;

    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print("in get location");

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

  Widget Page() {
    return Container(
      child: Center(
        child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
