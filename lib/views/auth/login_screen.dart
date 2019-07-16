import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/model/phone_and_pin.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/auth/otp.dart';
import 'package:seclot/views/widget/ui_snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UISnackBarProvider{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool loading = false;
  bool errorOccured = false;
  String _errorMessage = "";

  String _firstName;
  String _lastName;
  String _reenterPin;

  int _errorCode;

//  LoginDetails _loginDetails = LoginDetails(" ", " ");
  var _phoneController = TextEditingController();
  var _pinController = TextEditingController();

  bool _autoLogi;
  LocalStorageHelper _pref;
  String _phoneNumber = "";
  String _pin = "";

  var _rememberMe = true;

  @override
  void initState() {
    LocalStorageHelper().getPhoneAndPin().then((value) {
      if (value.isNotEmpty) {
        var decode = json.decode(value);

        // print(decode);
        setState(() {
          _phoneNumber = decode['phoneNumber'];
          _pin = decode['pin'];

          _phoneController.text = _phoneNumber;
          _pinController.text = _pin;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onSubmit(String value) {
      // print(value);
    }

    return new Scaffold(
      key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: WillPopScope(
          onWillPop: () {
            if (loading) {
              setState(() {
                loading = false;
                errorOccured = false;
              });
            }
          },
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
                      onPressed: () {},
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
      ),
    )));
  }

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void login() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      showLoadingSnackBar();

//      setState(() {
//        print("setting state");
//        loading = true;
//      });

      APIService()
          .performLogin(_phoneNumber, _pin, _rememberMe)
          .then((value) {

        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutUtils.home, (Route<dynamic> route) => false);

      }).catchError((error) {
        // print("RESPONSE FROM LOGIN => $value");
        showInSnackBar( "Error signing please check your network and try again");
      });
    }else{
      showInSnackBar("Please enter a valid phonenumber and password");
    }
  }
}
