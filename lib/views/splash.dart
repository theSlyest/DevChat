import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../utils/routes_utils.dart';
//import 'package:paystack_sdk/paystack_sdk.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var error = false;

  @override
  void initState() {
    super.initState();

//    Future<void> initPaystack() async {
//      String paystackKey = "pk_test_71cb8fa98c03c73d3ff040d7ba712af4921b3bf9";
//      try {
//        await PaystackSDK.initialize(paystackKey);
//        // Paystack is ready for use in receiving payments
//      } on PlatformException {
//        // well, error, deal with it
//      }
//    }

    checkLoginDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.grey[600],
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: Page(),
      ),
    );
  }

  void checkLoginDetails() {
    LocalStorageHelper().getLoginDetails().then((details) {
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
    });
  }

  Widget Page() {
    return !error
        ? Container(
            child: Center(
              child: SizedBox(
                width: 100.0,
                height: 100.0,
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Ooops, error signing in!!!\nPlease check your internet connection and hit retry below",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        error = false;
                      });

                      checkLoginDetails();
                    },
                    child: Text("RETRY"),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutUtils.login, (Route<dynamic> route) => false);
                    },
                    child: Text("SIGNOUT"),
                  )
                ],
              ),
            ),
          );
  }
}
