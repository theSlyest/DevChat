import 'package:flutter/material.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/auth/otp.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final phoneNumberTextFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

    return new Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Container(
              margin: EdgeInsets.only(top: 100.0),
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
                    style: TextStyle(fontSize: 36.0),
                  ),
                  SizedBox(height: 48.0),
                  TextFormField(
                    validator: (value) {
                      if (value.length != 11) {
                        return 'Please enter a valid phone number';
                      }
                    },
                    maxLength: 11,
                    controller: phoneNumberTextFieldController,
                    style: TextStyle(fontSize: 24.0, color: Colors.black54),
                    decoration: InputDecoration(
                      labelText: 'Phone #',
                      labelStyle: TextStyle(
                        fontSize: 24.0,
                      ),
                      hintText: '080-1234-4567',
                      hintStyle: TextStyle(
                        fontSize: 24.0,
                        height: 1.5,
                      ),
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 48.0),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutUtils.otp);
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
                  ),
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
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    )));
  }
}
