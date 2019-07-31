import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:flutter/services.dart';

class GetLocationScreen extends StatefulWidget {
  @override
  _GetLocationScreenState createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen>
    with WidgetsBindingObserver {
  PermissionState state = PermissionState.loading;
  AppStateProvider appStateProvider;

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);

    print("in build");

    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(24),
          alignment: Alignment.center,
          child: Center(child: getScreen(state))),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    print("resumed");
    Future.delayed(Duration.zero, () => checkPermission());
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      print("resumed");
      Future.delayed(Duration.zero, () => checkPermission());
    }
  }

  checkPermission() async {
    setState(() {
      state = PermissionState.loading;
    });

    print("checking permission");
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();

    if (permission == PermissionStatus.granted) {
      print("permission granted");
      //navigate to main screen
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      setState(() {
        state = PermissionState.denied;
      });
    } else if (permission == PermissionStatus.unknown ||
        permission == PermissionStatus.restricted) {
      setState(() {
        state = PermissionState.disabled;
      });
    } else {
      print("checking for service status");
      ServiceStatus serviceStatus =
          await LocationPermissions().checkServiceStatus();
      if (serviceStatus == ServiceStatus.enabled) {
        await requestPermission();
      } else if (serviceStatus == ServiceStatus.notApplicable ||
          serviceStatus == ServiceStatus.notApplicable) {
        setState(() {
          state = PermissionState.not_applicable;
        });
      } else if (serviceStatus == ServiceStatus.disabled ||
          serviceStatus == ServiceStatus.unknown) {
//        bool isOpened = await LocationPermissions().openAppSettings();
        setState(() {
          state = PermissionState.disabled;
        });
      }
    }
  }

  Future requestPermission() async {
    print("requesting permission");

    PermissionStatus permission =
        await LocationPermissions().requestPermissions();

    print("permision done");
    if (permission == PermissionStatus.granted) {
      //continue
      print("getting location");
      getLocation();
    } else {
      setState(() {
        state = PermissionState.denied;
      });
    }
  }

  Widget getScreen(PermissionState state) {
    switch (state) {
      case PermissionState.loading:
        {
          return Center(child: CircularProgressIndicator());
        }
      case PermissionState.denied:
        {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Permission denied!!"),
                  Text(
                      "Seclot needs your permission to access your location details\n\nClick below to grant permission",
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 8,
                  ),
                  RaisedButton(
                    onPressed: () {
                      requestPermission();
                    },
                    child: Text("Grant Permission"),
                  )
                ],
              ),
            ),
          );
        }
      case PermissionState.disabled:
        {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Location service disabled!!"),
                  Text(
                      "Seclot cant get your location details, as it is disabled"
                      "\n\nClick below to enable it from your phone settings.",
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 8,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await LocationPermissions().openAppSettings();
                    },
                    child: Text("Goto Settings"),
                  )
                ],
              ),
            ),
          );
        }
      case PermissionState.not_applicable:
      default:
        {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Location service not found!!"),
                  Text(
                      "Seclot cant work on this phone as it cant find your location service"
                      "\n\nplease check settings to enable it if it is disabled..",
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 8,
                  ),
                  RaisedButton(
                    onPressed: () {
                      requestPermission();
                    },
                    child: Text("Enable Location"),
                  )
                ],
              ),
            ),
          );
        }
    }
  }

  void gotoSplashScreen() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RoutUtils.splash, (_) => false);
  }

  Future getLocation() async {
    print("getting location");
    LocationData currentLocation;

    var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print("in get location");
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            state = PermissionState.disabled;
          });
        }
      });

      currentLocation = await location.getLocation();
      print("location set");
      appStateProvider.setLocation(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude);

      gotoSplashScreen();
    } on PlatformException catch (e) {
      print("error getting location");
      if (e.code == 'PERMISSION_DENIED') {
        setState(() {
          state = PermissionState.denied;
        });
      } else {
        setState(() {
          state = PermissionState.not_applicable;
        });
      }
//      appStateProvider.setLocation(latitude: 9.0820, longitude: 8.6753);
      gotoSplashScreen();

      currentLocation = null;
    }

    print("outside get location");
    setState(() {
      state = PermissionState.disabled;
    });
  }
}

enum PermissionState { loading, denied, disabled, not_applicable }
