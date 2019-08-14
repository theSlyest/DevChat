import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/data_store/user_details.dart';
import 'package:seclot/model/ice.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/scopped_model/user_scopped_model.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/utils/location_helper.dart';

import 'make_call_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.appStateProvider);
  final AppStateProvider appStateProvider;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _sendingCallIndicator = 0.0;
  var _callInProgress = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var localStorage = LocalStorageHelper();

  bool dataFetched = false;
  bool dataSet = false;
  Widget navigationDrawer() {
    const double textSize = 16.0;
    const double iconSize = 22.0;
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 160,
            child: DrawerHeader(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                              image: DecorationImage(
                                  image: appStateProvider
                                          .user.picture.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          appStateProvider.user.picture)
                                      : AssetImage(ImageUtils.person_avatar),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
//                          _name,
                            "${appStateProvider.user.firstName} ${appStateProvider.user.lastName}",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
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
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 4.0, right: 16.0),
            child: ListTile(
              title: Text(
                'Home',
                style: TextStyle(fontSize: textSize),
              ),
              leading: ImageIcon(
                AssetImage(ImageUtils.home),
                size: iconSize,
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
                size: iconSize,
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
                size: iconSize,
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
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(fontSize: textSize),
                    ),
                  ),
                  /*Text(
                    '${appStateProvider.unreadMessageCount}',
                    style: TextStyle(fontSize: 16),
                  ),*/
                  appStateProvider.unreadMessageCount != null &&
                          appStateProvider.unreadMessageCount > 0
                      ? Container(
//                    height: 40,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Text(
                            '${appStateProvider.unreadMessageCount}',
                            style: TextStyle(
                                fontSize: textSize, color: Colors.white),
                          ),
                        )
                      : SizedBox()
                ],
              ),
              leading: Icon(
                EvaIcons.bellOutline,
                color: Colors.grey,
                size: iconSize,
              ),
              onTap: () {
                appStateProvider.clearUnread();
                Navigator.pop(context);
                Navigator.pushNamed(context, RoutUtils.notification);
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
                size: iconSize,
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
                size: iconSize,
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
                    size: iconSize,
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
  void initState() {
    appStateProvider = widget.appStateProvider;

    fetchData();
    setupLocalNotification();
    setupFCM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "LOCATION => ${appStateProvider.latitude} | ${appStateProvider.longitude}");
    print(
        "USER LOCATION => ${appStateProvider.user.latitude} | ${appStateProvider.user.longitude}");

    if (appStateProvider.latitude == -0.0 &&
        appStateProvider.longitude == -0.0) {
      _checkLocation();
    } else {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    }

    return Scaffold(
        key: _scaffoldKey,
        drawer: navigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
//          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                appStateProvider.clearUnread();
                Navigator.pushNamed(context, RoutUtils.notification);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 8),
                child: Stack(
                  children: <Widget>[
                    Icon(
                      EvaIcons.bellOutline,
                    ),
                    Positioned(
                      right: 0,
                      child: appStateProvider.unreadMessageCount != null &&
                              appStateProvider.unreadMessageCount > 0
                          ? Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                            )
                          : SizedBox(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder<IceDAO>(
              stream: iceController,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!dataSet) {
                    Future.delayed(Duration.zero, () {
                      appStateProvider.ice = snapshot.data;
                    });
                  }
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Help', style: TextStyle(fontSize: 32.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('..A button away',
                            style: TextStyle(fontSize: 18.0)),
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MakeCallScreen()));
                                    },
                                    child: Text(
                                      'Distress Call',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    )))),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Column(
                    children: <Widget>[
                      Text("Error feching data, please check your network"),
                      FlatButton.icon(
                          onPressed: () {
                            fetchData();
                            setState(() {});
                          },
                          icon: Icon(EvaIcons.refreshOutline),
                          label: Text("Retry"))
                    ],
                  ));
                }

                return Center(child: CircularProgressIndicator());
              }),
        )));
  }

  Widget getView() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

    userModel.setUser(profile.getUserData());

    return profile;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 4,
    );
  }

  void setupFCM() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
//        _showItemDialog(message);
        showNotification(
            message["notification"]["title"], message["notification"]["body"]);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        _navigateToItemDetail(message);
        Navigator.pushNamed(context, RoutUtils.notification);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      /*
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);*/

      if (token != null) {
        sendToken(token);
      }
    });
  }

  Future sendToken(String fcmToken) async {
    bool sent = false;
    try {
      sent = await localStorage.hasSentToken();
    } catch (e) {}

    if (!sent) {
      appStateProvider.saveFCMToken(fcmToken);
      APIService()
          .registerNotificationID(appStateProvider.token, fcmToken)
          .then((response) {
        print(response.body);
        print(response.statusCode);

        if (response.statusCode == 200) {
          localStorage.sentToken();
          print("Token sent");
        }
      });
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  setupLocalNotification() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_stat_name');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    Navigator.pushNamed(context, RoutUtils.notification);
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    Navigator.pushNamed(context, RoutUtils.notification);
  }

  showNotification(String subject, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '0', 'seclot_flutter_notification', 'Notification from seclot',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        700, '$subject', '$message', platformChannelSpecifics,
        payload: 'item x');
  }

  Observable<IceDAO> iceController;
  void fetchData() {
    iceController = Observable.fromFuture(
        APIService.getInstance().fetchIce(appStateProvider.token));
  }

  void _checkLocation() {
    Future.delayed(Duration.zero, () async {
      await getLocation(context, appStateProvider, () {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
                "Location not available, you will not be able to send a distress call"),
            action: SnackBarAction(
                label: "Get Location",
                onPressed: () {
                  _checkLocation();
                }),
            duration: Duration(days: 1),
          ),
        );
      });
    });
  }
}
