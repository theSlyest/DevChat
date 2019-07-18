import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/network.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/data_store/user_details.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/scopped_model/user_scopped_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';

import 'make_call_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _sendingCallIndicator = 0.0;
  var _callInProgress = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var localStorage = LocalStorageHelper();

//  final userModel = UserModel();


  Widget navigationDrawer() {
    const double textSize = 18.0;
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width / 0.3,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      appStateProvider.user.picture.isNotEmpty
                          ? Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black, width: 1.0),
                            image: DecorationImage(
                                image:
                                CachedNetworkImageProvider(
                                    appStateProvider.user.picture),
                                fit: BoxFit.cover)),
                      )
                          : Container(
                          child: Image.asset(ImageUtils.person_avatar),
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black, width: 3.0))),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
//                          _name,
                          "${appStateProvider.user.firstName} ${appStateProvider.user.lastName}",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageUtils.nav_header_background_phone),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding:
            EdgeInsets.only(left: 24.0, top: 4.0, bottom: 8.0, right: 16.0),
            child: ListTile(
              title: Text(
                'Home',
                style: TextStyle(fontSize: textSize),
              ),
              leading: ImageIcon(
                AssetImage(ImageUtils.home),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 4.0, right: 16.0),
            child: ListTile(
              title: Text(
                'Profile',
                style: TextStyle(fontSize: textSize),
              ),
              leading: ImageIcon(
                AssetImage(ImageUtils.profile),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutUtils.view_profile);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 4.0, right: 16.0),
            child: ListTile(
              title: Text(
                'ICEs',
                style: TextStyle(fontSize: textSize),
              ),
              leading: ImageIcon(
                AssetImage(ImageUtils.ice),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutUtils.ices);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 4.0, right: 16.0),
            child: ListTile(
              title: Text(
                'History',
                style: TextStyle(fontSize: textSize),
              ),
              leading: ImageIcon(
                AssetImage(ImageUtils.history),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutUtils.history);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 4.0, right: 16.0),
            child: ListTile(
              title: Text(
                'Wallet',
                style: TextStyle(fontSize: textSize),
              ),
              leading: ImageIcon(
                AssetImage(ImageUtils.wallet),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutUtils.wallet);
              },
            ),
          ),
          Expanded(
            child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.only(left: 32.0),
                constraints: BoxConstraints.expand(height: 55.0),
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: textSize, color: Colors.white),
                  ),
                  leading: ImageIcon(
                    AssetImage(ImageUtils.logout),
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    LocalStorageHelper().saveLoginDetails("");
                    appStateProvider.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RoutUtils.splash, (Route<dynamic> route) => false);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  AppStateProvider appStateProvider;

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
        drawer: navigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Help', style: TextStyle(fontSize: 32.0)),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('..A button away', style: TextStyle(fontSize: 18.0)),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Center(
                            child: Image.asset(
                              ImageUtils.home_phone,
                              width: 300.0,
                            )),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 24.0),
                        child: SizedBox(
                            width: double.maxFinite,
                            height: MarginUtils.buttonHeight,
                            child: RaisedButton(
                                color: Colors.black,
                                onPressed: () {
//                              InputDialog();
//                                  _showDialog();

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakeCallScreen()));

                                },
                                child: Text(
                                  'Distress Call',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                )))),
                  ],
                ),
              ),
            )));
  }

  Widget getView() {
    return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
//            mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Sending...', style: TextStyle(fontSize: 48.0)),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future<UserDetails> getDetails() async {
    var profile = UserDetails();
    var currentLocation = <String, double>{};
    var location = new Location();

    /*try {
      location.getLocation().then((loc) {
        currentLocation = loc;

        APIService()
            .updateLocation(
                token: profile.getUserData().token,
                latitude: currentLocation["latitude"],
                longitude: currentLocation["longitude"])
            .then((success) {
          if (success) {
//            showToast("LOCATION UPDATED");
          } else {
            showToast(
                "Error updating location, ensure your location services is turned on and access granted to seclot");
          }
        });
      });
    } on PlatformException {
      currentLocation = null;
    }*/

    userModel.setUser(profile.getUserData());

    return profile;
//    setState(() {
//      _name =
//          "${profile.getUserData().firstName} ${profile.getUserData().lastName}";
//    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 4,
    );
  }

  void setupFirebaseMessaging() {
    /*_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));*/
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
//    });
    localStorage.hasSentToken().then((sent) {
      if (!sent) {
        _firebaseMessaging.getToken().then((String notificationId) {
//      assert(token != null);
          if (notificationId != null) {
            print("Messaging oken => $notificationId");
            localStorage.getToken().then((token) {
              if (token.isNotEmpty) {
                APIService()
                    .registerNotificationID(token, notificationId)
                    .then((response) {
                  print(response.body);
                  print(response.statusCode);

                  if (response.statusCode == 200) {
                    localStorage.sentToken();
                    print("Token sent");
                  }
                });
              }
            });
          }
        });
      }
    });
  }
}
