import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/new_user.dart';
import 'package:seclot/views/widget/ui_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String authCode;

//  const OTPScreen({this.phoneNumber});
  const ForgotPasswordScreen({Key key, @required this.authCode})
      : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with UISnackBarProvider {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _pinController = TextEditingController();

  String _pin;

  @override
  void initState() {
    print("${widget.authCode}");

    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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
              return null;
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
              if (_pinController.text == null || _pinController.text != value) {
                return 'Invalid pin, Please enter same pin as above';
              }
              return null;
            },
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

  AppStateProvider appStateProvider;

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Note: If you exit now, you will have to start the process afresh.'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('CONTINUE'),
          ),
          new FlatButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, RoutUtils.login, (_) => false);
    },
            child: new Text('EXIT'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);
    return WillPopScope(child: Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: Text("SET NEW PIN"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your new pin below",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                pin(),
                reenter_pin(),
                SizedBox(
                  height: 20.0,
                ),
                forgot_password(context)
              ],
            ),
          ),
        ),
      ),
    ),

        onWillPop: _onWillPop);
  }

  Widget forgot_password(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: () async {
          try {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              showLoadingSnackBar();

              var value = await APIService()
                  .setPin(authCode: widget.authCode, pin: _pin);

              showInSnackBar("New password changed");

              appStateProvider.user = value.user;
              appStateProvider.token = value.token;
              appStateProvider.password = _pin;
              value.password = _pin;
              appStateProvider.saveDetails(value);

              Future.delayed(
                  Duration(seconds: 2),
                  () => Navigator.of(context).pushNamedAndRemoveUntil(
                      RoutUtils.home, (Route<dynamic> route) => false));
            }
          } catch (e) {
            print(e);

            showInSnackBar(
                "Error setting pin, please check your network and try again");
          }
        },

        elevation: 8.0,
//                  splashColor: Colors.white,
        minWidth: double.infinity,
        height: 48.0,
        color: Colors.black,
        child: Text(
          'SET NEW PIN',
          style: TextStyle(fontSize: 16.0),
        ),
        textColor: Colors.white,
      ),
    );
  }

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}
