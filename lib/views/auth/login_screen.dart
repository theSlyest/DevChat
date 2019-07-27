import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/model/phone_and_pin.dart';
import 'package:seclot/model/user.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/auth/otp.dart';
import 'package:seclot/views/auth_screen.dart';
import 'package:seclot/views/widget/ui_snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UISnackBarProvider {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _phoneController = TextEditingController();
  var _pinController = TextEditingController();

  String _phoneNumber = "";
  String _pin = "";

  var _rememberMe = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  AppStateProvider appStateProvider;

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);

    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('resources/images/logo.jpeg',
                          // height: 200.0,
                          width: 200.0),
                      SizedBox(height: 48.0),
                      Text(
                        'USER LOGIN',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        controller: _phoneController,
                        validator: (value) {
                          if (value.length != 11) {
                            return 'Please enter a valid phone number';
                          }

                          return null;
                        },
                        onSaved: (String val) {
                          _phoneNumber = val;
                        },
                        maxLength: 11,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Phone #',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                          ),
                          hintText: '080-1234-4567',
                          hintStyle: TextStyle(
                            fontSize: 18.0,
                            height: 1.5,
                          ),
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 4.0),
                      TextFormField(
                        obscureText: true,
                        controller: _pinController,
                        validator: (value) {
                          if (value.length != 5) {
                            return 'Invalid pin';
                          }

                          return null;
                        },
                        onSaved: (String val) {
                          _pin = val;
                        },
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Enter PIN',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                          ),
                          Text("Remember me")
                        ],
                      ),
                      SizedBox(height: 8.0),
//                    _getErrorText(),
                      MaterialButton(
                        onPressed: login,
                        elevation: 8.0,
//                  splashColor: Colors.white,
                        minWidth: double.infinity,
                        height: 48.0,
                        color: Colors.black,
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't have an account?"),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, RoutUtils.auth);
                                },
                                child: Text(
                                  "SIGN UP HERE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ))
                          ],
                        ),
                      ),
                      Center(
                          child: FlatButton(
                        onPressed: () {
//                          Navigator.pushNamed(context, RoutUtils.auth);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen(forgot: true)));
                        },
                        child: Text(
                          "Forgot password?",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )),
                    ],
                  ),
                )),
          ),
        )));
  }

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  Future login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        showLoadingSnackBar();

        var userData =
            await APIService().performLogin(_phoneNumber, _pin, _rememberMe);

        showInSnackBar("Login success");

//      print("signin succes token => ${userData.user.toJson()}");
//      print("signin succes token => ${userData.token}");

        if (_rememberMe) {
          appStateProvider.user = userData.user;
          appStateProvider.token = userData.token;
          appStateProvider.password = _pin;
          appStateProvider.saveDetails(userData);
        }

        Future.delayed(
            Duration(seconds: 2),
            () => Navigator.of(context).pushNamedAndRemoveUntil(
                RoutUtils.home, (Route<dynamic> route) => false));
      } catch (err) {
        print(err);

        if (err == null || err.message == null || err.message.isEmpty) {
          showInSnackBar(
              "Login failed!! Please check your internet, enter a valid phone number and password and try again");
        } else {
          showInSnackBar("${err.message}");
        }
      }
    } else {
      showInSnackBar(
          "Login failed!! Please check your internet, enter a valid phone number and password and try again");
    }
  }
}
