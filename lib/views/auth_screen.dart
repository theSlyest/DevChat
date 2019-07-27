import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/auth/otp.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({this.forgot = false});

  bool forgot;
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final phoneNumberTextFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber;
  bool loading = false;
  bool errorOccured = false;
  Timer _timer;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    phoneNumberTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _onSubmit(String value) {
      print(value);
    }

    Widget _login() {
      return loading
          ? Center(child: CircularProgressIndicator())
          : MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

//            Navigator.push(context, MaterialPageRoute(
//              builder: (context) => OTPScreen(phoneNumber: _phoneNumber),
//            ));

                  setState(() {
                    loading = true;
                  });

                  APIService().requestOTP("$_phoneNumber").then((bool) {
                    errorOccured = bool;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OTPScreen(phoneNumber: _phoneNumber, forgot: widget.forgot),
                        ));

                    setState(() {
                      loading = false;
                    });
                  });

                  Future.delayed(const Duration(seconds: 15), () {
                    if (loading) {
                      setState(() {
                        errorOccured = true;
                        loading = false;
                      });
                    }
                  });
                }
              },
              elevation: 8.0,
//                  splashColor: Colors.white,
              minWidth: double.infinity,
              height: 58.0,
              color: Colors.black,
              child: Text(
                'CONTINUE',
                style: TextStyle(fontSize: 16.0),
              ),
              textColor: Colors.white,
            );
    }

    ;

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Container(
              margin: EdgeInsets.only(top: 40.0),
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
                    'Enter your Phone',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    validator: (value) {
                      if (value.length != 11) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    maxLength: 11,
                    controller: phoneNumberTextFieldController,
                    onSaved: ((value) {
                      _phoneNumber = value;
                    }),
                    style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
                  SizedBox(height: 24.0),
                  _login(),
                  SizedBox(height: 24.0),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?"),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "SIGN IN HERE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  _getErrorText(),
                ],
              ),
            )),
      ),
    )));
  }

  _getErrorText() {
    if (errorOccured) {
      Future.delayed(Duration(milliseconds: 4000), () {
        if(mounted){
          setState(() {
            errorOccured = false;
          });
        }
      });

      return SizedBox(
        height: 24.0,
        child: Center(
          child: Text(
            "Error sending verification code, please check your network "
                "and try again",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      return Text(
        "",
        style: TextStyle(fontSize: 1.0),
      );
    }
  }
}
