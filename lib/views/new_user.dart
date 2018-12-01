import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../utils/color_conts.dart';
import '../utils/margin_utils.dart';
import '../utils/routes_utils.dart';
import '../views/create_profile.dart';

class NewUserScreen extends StatefulWidget {
//  const OTPScreen({this.phoneNumber});
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();
  var _pinController = TextEditingController();
  var _reenterPinController = TextEditingController();

  bool loading = false;
  bool errorOccured = false;

  String _firstName;
  String _lastName;
  String _pin;
  String _reenterPin;
  String _email;
  String _address;
  String _errorText =
      "Error creating account, please check your network and try again";

  Map<String, dynamic> _locationMap = Map();

  @override
  void initState() {
    loading = false;
    FlutterPlacesDialog.setGoogleApiKey(
        "AIzaSyBRTlfkTgxhu0f5-GovEpKviJUDyfqyEv8");
//    getLocation();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pinController.dispose();
    _reenterPinController.dispose();
    super.dispose();
  }

  Widget first_name() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.person,
          size: 24.0,
          color: ColorUtils.dark_gray,
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your first name';
              }
            },
            controller: _firstNameController,
            onSaved: ((value) {
              _firstName = value;
            }),
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
              labelText: 'First name',
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget last_name() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.person,
          size: 24.0,
          color: ColorUtils.dark_gray,
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your last name';
              }
            },
            controller: _lastNameController,
            onSaved: ((value) {
              _lastName = value;
            }),
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Last name',
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget email() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.mail,
          size: 24.0,
          color: ColorUtils.dark_gray,
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            maxLines: 1,
            validator: (value) {
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(value))
                return 'Please enter a valid email';
              else
                return null;
            },
            controller: _emailController,
            onSaved: ((value) {
              _email = value;
            }),
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  final inputFontStyle = 18.0;
  final inputLabel = 16.0;
  final inputSeperator = 20.0;
  var spacing = EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0);

  Widget address() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.location_on,
          size: 24.0,
          color: ColorUtils.dark_gray,
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FocusScope(
              node: new FocusScopeNode(),
              child: TextFormField(
                controller: _addressController,
//                      validator: validateAddress,
                onSaved: (value) {
//                        _referalID = value;
                },
                style: TextStyle(fontSize: 18.0, color: Colors.black54),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Current location',
                  labelStyle: TextStyle(
                    fontSize: inputFontStyle,
                  ),
                ),
                autofocus: true,
//          keyboardType: TextInputType.phone,
              ),
            ),
            GestureDetector(
              onTap: _view_map,
              child: Text(
                "View Map",
                style: TextStyle(color: Colors.blue, fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Divider(
              height: 3.0,
              color: Colors.black,
            )
          ],
        )),
      ],
    );
  }

  Widget pin() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 24.0,
          color: ColorUtils.dark_gray,
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            maxLines: 1,
            obscureText: true,
            maxLength: 5,
            validator: (value) {
              if (value.length != 5) {
                return 'Please enter a 5 digit pin';
              }
            },
            controller: _pinController,
            onSaved: ((value) {
              _pin = value;
            }),
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
              labelText: 'New pin',
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget reenter_pin() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.lock,
          size: 24.0,
          color: ColorUtils.dark_gray,
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: TextFormField(
            maxLines: 1,
            obscureText: true,
            maxLength: 5,
            validator: (value) {
              if (_pinController.text == null ||
                  value.compareTo(_pinController.text) != 0) {
                print("$value-$_pin");

                return 'Please enter same pin as above';
              }
            },
            controller: _reenterPinController,
            onSaved: ((value) {
              _reenterPin = value;
            }),
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Confirm pin',
              labelStyle: TextStyle(
                fontSize: 18.0,
              ),
            ),
            autofocus: true,
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData(primaryColor: Colors.black, primaryColorDark: Colors.black, accentColor: Colors.black),

      home: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: Text("ACCOUNT SETUP"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Enter your details below to get started",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  first_name(),
                  SizedBox(
                    height: 10.0,
                  ),
                  last_name(),
                  SizedBox(
                    height: 10.0,
                  ),
                  email(),
                  SizedBox(
                    height: 10.0,
                  ),
                  address(),
                  SizedBox(
                    height: 10.0,
                  ),
                  pin(),
                  reenter_pin(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _getErrorText(),
                  _login(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _login(context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  LocalStorageHelper().getAuthCode().then((auth) {
                    if (auth.isEmpty) {
                      //error signing
                      //navigate to login

                      showErrorToast();
                    } else {
                      var body = Map<String, dynamic>();
                      body["authCode"] = auth;

                      body["firstName"] = _firstName;
                      body["lastName"] = _lastName;
                      body["email"] = _lastName;
                      body["pin"] = _pin;

                      if (_place != null) {
                        body["location"] = getLocation();
                      } else {
                        _errorText =
                            "Error getting location, please make sure your location is tured on, and select your address from the map";

                        setState(() {
                          errorOccured = true;
                        });

                        return;
                      }

                      print("BREAK");
                      print(body);

                      setState(() {
                        errorOccured = false;
                        loading = true;
                      });

                      APIService().newUser(body).then((response) {
                        if (response.statusCode == 200) {
                          errorOccured = false;

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutUtils.home, (Route<dynamic> route) => false);
                        } else {
                          _errorText = response.body;
                          errorOccured = true;
                        }

                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  });
                }
              },

              elevation: 8.0,
//                  splashColor: Colors.white,
              minWidth: double.infinity,
              height: 48.0,
              color: Colors.black,
              child: Text(
                'CREATE ACCOUNT',
                style: TextStyle(fontSize: 16.0),
              ),
              textColor: Colors.white,
            ),
          );
  }

  _getErrorText() {
    if (errorOccured) {
//      _timer = new Timer(const Duration(milliseconds: 4000), () {
//        setState(() {
//          errorOccured = false;
//        });
//      });

      return Column(
        children: <Widget>[
          Center(
            child: Text(
              "$_errorText",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
        ],
      );
    } else {
      return Text(
        "",
        style: TextStyle(fontSize: 1.0),
      );
    }
  }

  PlaceDetails _place;
  Map<String, dynamic> getLocation() {
    if (_place != null) {
      _locationMap["latitude"] = _place.location.latitude; //position.latitude;
      _locationMap["longitude"] =
          _place.location.longitude; //position.longitude;

      return _locationMap;
    }

    return null;
  }

  void _view_map() {
    _showPlacePicker();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _showPlacePicker() async {
    PlaceDetails place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await FlutterPlacesDialog.getPlacesDialog();
    } on PlatformException {
      place = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

//    print("$place");

//    _addressController.text = place.address;
//    _latitude = place.location.latitude as String;
//    _longitude = place.location.longitude as String;
    setState(() {
      _addressController.text =
          "lat: ${place.location.latitude}; lon: ${place.location.longitude}";
      _place = place;
    });
  }

  void showErrorToast() {
    Fluttertoast.showToast(
        msg:
            "We couldn't create your account at this time, please try again after 60 seconds",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 4,
        bgcolor: "#e74c3c",
        textcolor: '#ffffff');

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutUtils.login, (Route<dynamic> route) => false);
    });

//    final scaffold = Scaffold.of(context);
//    scaffold.showSnackBar(
//      SnackBar(
//        backgroundColor: Colors.green,
//        duration: Duration(seconds: 5),
//        content: Text(
//          "We couldnt create your account at this time, please try again after 60 seconds",
//          textAlign: TextAlign.center,
//        ),
//      ),
//    );
  }
}
