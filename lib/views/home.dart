import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/network.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seclot/scopped_model/user_scopped_model.dart';
import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../data_store/user_details.dart';
import '../utils/color_conts.dart';
import '../utils/image_utils.dart';
import '../utils/margin_utils.dart';
import '../utils/routes_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _sendingCallIndicator = 0.0;
  var _callInProgress = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Timer _timer;
  String _text1;
  String _text2;
  String _text3;
  String _text4;

  var _focusNode1 = new FocusNode();
  var _focusNode2 = new FocusNode();
  var _focusNode3 = new FocusNode();
  var _focusNode4 = new FocusNode();

  var _controller1 = new TextEditingController(text: " ");
  var _controller2 = new TextEditingController(text: " ");
  var _controller3 = new TextEditingController(text: " ");
  var _controller4 = new TextEditingController(text: " ");

  String _name = "";

  var localStorage = LocalStorageHelper();

//  final userModel = UserModel();

  @override
  void initState() {
    super.initState();

    setupFirebaseMessaging();
    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        _controller1.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller1.value.text.length);
      }
    });

    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        _controller2.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller2.value.text.length);
      }
    });

    _focusNode3.addListener(() {
      if (_focusNode3.hasFocus) {
        _controller3.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller3.value.text.length);
      }
    });

    _focusNode4.addListener(() {
      if (_focusNode4.hasFocus) {
        _controller4.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller4.value.text.length);
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();

    super.dispose();
  }

  Widget textFields() {
    double height = 50.0; //
    double width = MediaQuery.of(context).size.width / 8; //70.0;

    double fontSize = 24.0;

    var boxDecoration = BoxDecoration(
        color: ColorUtils.light_gray,
        borderRadius: BorderRadius.circular(10.0));

    var margin = EdgeInsets.all(8.0);

    int maxLength = 1;

    _updateState() {}

    var firstTF = new TextField(
        focusNode: _focusNode1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller1,
        onChanged: (newVal) {
          FocusScope.of(context).requestFocus(_focusNode2);
          if (newVal.length <= maxLength) {
          } else {
            _controller1.text = newVal[newVal.length - 1];
          }

          if (newVal.length != 0) {
            setState(() {
              FocusScope.of(context).requestFocus(_focusNode4);
            });
          }

//          print("new value ==> $newVal");

          _updateState();
        });

    var secondTF = new TextField(
        focusNode: _focusNode2,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller2,
        onChanged: (newVal) {
          if (newVal.length <= maxLength) {
            _text2 = newVal;
          } else {
            _controller2.text = _text2;
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode3);
          }
          _updateState();
        });

    var thirdTF = new TextField(
        focusNode: _focusNode3,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller3,
        onChanged: (newVal) {
          if (newVal.length <= maxLength) {
            _text3 = newVal;
          } else {
            _controller3.text = _text3;
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode4);
          }
          _updateState();
        });

    var fourthTF = new TextField(
        focusNode: _focusNode4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller4,
        onChanged: (newVal) {
          if (newVal.length <= maxLength) {
            _text4 = newVal;
          } else {
            _controller4.text = _text4;
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode1);
          }
          _updateState();
        });

    return Card(
      child: Column(
        children: <Widget>[
          Text('Enter pin to stop message'),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Expanded(
                  child: Container(
                    height: height,
                    width: width,
                    margin: margin,
                    decoration: boxDecoration,
                    child: Center(child: firstTF),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height,
                    width: width,
                    margin: margin,
                    decoration: boxDecoration,
                    child: Center(child: secondTF),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height,
                    width: width,
                    margin: margin,
                    decoration: boxDecoration,
                    child: Center(child: thirdTF),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height,
                    width: width,
                    margin: margin,
                    decoration: boxDecoration,
                    child: Center(child: fourthTF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textField() {
    return SizedBox(
      height: 48.0,
      child: Container(
        child: TextField(
            autofocus: true,
            maxLength: 5,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: new TextStyle(fontSize: 24.0, color: Colors.black),
            controller: _controller1,
            onChanged: (newVal) {
              if (newVal.length == 5) {
                LocalStorageHelper().getPin().then((pin) {
                  if (pin == newVal) {
                    //correct pin cancel
//                    print("Input complete");
                    _dialogDismissed = true;
                    _callCanceled = true;
                    Navigator.of(context, rootNavigator: true).pop();
                    showToast("Call cancelled");

                    setState(() {
                      _callInProgress = false;
                    });
                  } else if (pin.split('').reversed.join('') == newVal) {
//                    print("Input complete");
                    _dialogDismissed = true;
                    Navigator.of(context, rootNavigator: true).pop();
                    showToast("Call cancelled");

                    setState(() {
                      _callInProgress = false;
                    });
                  }
                });

                setState(() {
                  _invalid_Pin = true;
                });
              }
            }),
      ),
    );
  }

  var _invalid_Pin = false;
  Widget _invalidPin() {
    return _invalid_Pin ? Text('Invalid pin') : Text('');
  }

  bool _callCanceled = false;
  bool _dialogDismissed = false;
  void _showDialog() {
    _controller1.text = "";
    _controller2.text = "";
    _controller3.text = "";
    _controller4.text = "";
    updateProgress();

    // flutter defined function
    showDialog(
      context: context,
//      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          // title: new Text("Alert Dialog title"),
          content: SizedBox(
              height: 120.0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Enter pin to stop message'),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: textField(),
                  ),

                  /*Expanded(
                    child: textFields(),
                  ),*/
                  _invalidPin(),
                ],
              )),
          contentPadding: EdgeInsets.all(4.0),
        );
      },
    );
  }

  void updateProgress() {
//    _dialogDismissed = false;
    setState(() {
      _callInProgress = true;
    });

    Future.delayed(const Duration(seconds: 20), () {
//      print("AFTER 10 SECONDS DELAY");
      if (!_dialogDismissed) {
        Navigator.of(context, rootNavigator: true).pop();
        _dialogDismissed = true;
      }

      setState(() {
        _callInProgress = false;

        if (!_callCanceled) {
//          print("MAKING A DISTRESS CALL NOW");
          _makeCall();
        } else {
//          print("CALL CANCELLED BY THE USER");
        }
      });
    });
  }

  void _makeCall() {
    LocalStorageHelper().getToken().then((token) {
//      print("TOKEN => $token");

      APIService.getInstance().sendDistressCall(token).then((response) {
        print(response);
      }).catchError((error) {
        print(error);
      });
    });
  }

  Widget navigationDrawer() {
    const double textSize = 18.0;
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Column(
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
                      userModel.getUserData().picture.isNotEmpty
                          ? Container(
                              height: 100.0,
                              width: 100.0,
                              /*child: FadeInImage(
                      placeholder: AssetImage(ImageUtils.person_avatar),
                      image: CachedNetworkImageProvider(
                          userModel.getUserData().picture),
                    ),*/
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  image: DecorationImage(
                                      image:
                                          /*AdvancedNetworkImage(
                                userModel.getUserData().picture,
                                useDiskCache: true)*/
                                          CachedNetworkImageProvider(
                                              userModel.getUserData().picture),
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
                      /* Container(
                        child: Image.asset(ImageUtils.person_avatar),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.black, width: 3.0)),
                      ),*/
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
//                          _name,
                          "${model.user.firstName} ${model.user.lastName}",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

//                FlatButton(onPressed: (){},
//                  child: Text("View Profile"),
//                )
                ],
              ),
            ),
            decoration: BoxDecoration(
//            color: Colors.black,
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
                // Update the state of the app
                // ...
                // Then close the drawer
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
                // Update the state of the app
                // ...
                // Then close the drawer
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
                // Update the state of the app
                // ...
                // Then close the drawer
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
                // Update the state of the app
                // ...
                // Then close the drawer
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
                // Update the state of the app
                // ...
                // Then close the drawer

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
                    // Update the state of the app
                    // ...
                    // Then close the drawer

                    Navigator.pop(context);
                    LocalStorageHelper().saveLoginDetails("");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RoutUtils.splash, (Route<dynamic> route) => false);
                  },
                ),
//              child: RaisedButton(onPressed: (){},
//                color: Colors.black,
//                child: new Text('LOGOUT', style: TextStyle(fontSize: 16.0, color: Colors.white),),
//
//              ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetails>(
      future: getDetails(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<UserDetails> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.done:
            return ScopedModel<UserModel>(
                model: userModel,
                child: Scaffold(
                    drawer: Drawer(child: navigationDrawer()),
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: Colors.black),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                    body: getView()));
        }
        return null; // unreachable
      },
    );
  }

  Widget getView() {
    return _callInProgress
        ? Container(
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
                /* Flexible(
                  child: textFields(),
                ),*/
              ],
            ),
          )
        : SafeArea(
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
                                _showDialog();
                              },
                              child: Text(
                                'Distress Call',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              )))),
                ],
              ),
            ),
          ));
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

class InputDialog extends StatefulWidget {
  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  var _sendingCallIndicator = 0.0;
  var _callInProgress = false;

  Timer _timer;
  String _text1;
  String _text2;
  String _text3;
  String _text4;

  var _focusNode1 = new FocusNode();
  var _focusNode2 = new FocusNode();
  var _focusNode3 = new FocusNode();
  var _focusNode4 = new FocusNode();

  var _controller1 = new TextEditingController(text: " ");
  var _controller2 = new TextEditingController(text: " ");
  var _controller3 = new TextEditingController(text: " ");
  var _controller4 = new TextEditingController(text: " ");

  String _name = "";

  var localStorage = LocalStorageHelper();

  @override
  void initState() {
    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        _controller1.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller1.value.text.length);
      }
    });

    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        _controller2.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller2.value.text.length);
      }
    });

    _focusNode3.addListener(() {
      if (_focusNode3.hasFocus) {
        _controller3.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller3.value.text.length);
      }
    });

    _focusNode4.addListener(() {
      if (_focusNode4.hasFocus) {
        _controller4.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller4.value.text.length);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();

    super.dispose();
  }

  Widget textFields() {
    double height = 50.0; //
    double width = MediaQuery.of(context).size.width / 8; //70.0;

    double fontSize = 24.0;

    var boxDecoration = BoxDecoration(
        color: ColorUtils.light_gray,
        borderRadius: BorderRadius.circular(10.0));

    var margin = EdgeInsets.all(8.0);

    int maxLength = 1;

    _updateState() {}

    var firstTF = new TextField(
        focusNode: _focusNode1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller1,
        onChanged: (newVal) {
          FocusScope.of(context).requestFocus(_focusNode2);
          if (newVal.length <= maxLength) {
          } else {
            _controller1.text = newVal[newVal.length - 1];
          }

          if (newVal.length != 0) {
            setState(() {
              FocusScope.of(context).requestFocus(_focusNode4);
            });
          }

//          print("new value ==> $newVal");

          _updateState();
        });

    var secondTF = new TextField(
        focusNode: _focusNode2,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller2,
        onChanged: (newVal) {
          if (newVal.length <= maxLength) {
            _text2 = newVal;
          } else {
            _controller2.text = _text2;
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode3);
          }
          _updateState();
        });

    var thirdTF = new TextField(
        focusNode: _focusNode3,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller3,
        onChanged: (newVal) {
          if (newVal.length <= maxLength) {
            _text3 = newVal;
          } else {
            _controller3.text = _text3;
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode4);
          }
          _updateState();
        });

    var fourthTF = new TextField(
        focusNode: _focusNode4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller4,
        onChanged: (newVal) {
          if (newVal.length <= maxLength) {
            _text4 = newVal;
          } else {
            _controller4.text = _text4;
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode1);
          }
          _updateState();
        });

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          Expanded(
            child: Container(
              height: height,
              width: width,
              margin: margin,
              decoration: boxDecoration,
              child: Center(child: firstTF),
            ),
          ),
          Expanded(
            child: Container(
              height: height,
              width: width,
              margin: margin,
              decoration: boxDecoration,
              child: Center(child: secondTF),
            ),
          ),
          Expanded(
            child: Container(
              height: height,
              width: width,
              margin: margin,
              decoration: boxDecoration,
              child: Center(child: thirdTF),
            ),
          ),
          Expanded(
            child: Container(
              height: height,
              width: width,
              margin: margin,
              decoration: boxDecoration,
              child: Center(child: fourthTF),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    _controller1.text = "";
    _controller2.text = "";
    _controller3.text = "";
    _controller4.text = "";
//    updateProgress();

    // flutter defined function
    showDialog(
      context: context,
//      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          // title: new Text("Alert Dialog title"),
          content: SizedBox(
              height: 120.0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Enter pin to stop message'),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: textFields(),
                  ),

                  /*Expanded(
                    child: textFields(),
                  ),*/
//                  _invalidPin(),
                ],
              )),
          contentPadding: EdgeInsets.all(4.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: new Text("Alert Dialog title"),
      content: SizedBox(
          height: 120.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Text('Enter pin to stop message'),
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: textFields(),
              ),

              /*Expanded(
                    child: textFields(),
                  ),*/
//                  _invalidPin(),
            ],
          )),
      contentPadding: EdgeInsets.all(4.0),
    );
    ;
  }
}
