import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seclot/providers/AppStateProvider.dart';

import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../utils/routes_utils.dart';
//import 'package:paystack_sdk/paystack_sdk.dart';

class SplashScreen extends StatelessWidget {
  AppStateProvider appState;

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateProvider>(context);
    Future.delayed(Duration.zero, () => checkLoginDetails(context));

    return  Scaffold(
      body: Page(),
    );
  }

  Future checkLoginDetails(BuildContext context) async {

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
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutUtils.home, (Route<dynamic> route) => false);
    }
  }catch(e){
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
