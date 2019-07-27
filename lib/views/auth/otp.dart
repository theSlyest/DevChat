import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/new_user.dart';
import 'package:seclot/views/widget/ui_snackbar.dart';

import 'forgot_password.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final bool forgot;

//  const OTPScreen({this.phoneNumber});
  const OTPScreen({Key key, this.phoneNumber, this.forgot = false}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin, UISnackBarProvider {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  bool loading = false;
  bool otpLoading = false;
  bool errorOccured = false;
  bool otpErrorOccured = false;
  Timer _timer;

  var _focusNode1 = new FocusNode();
  var _focusNode2 = new FocusNode();
  var _focusNode3 = new FocusNode();
  var _focusNode4 = new FocusNode();

  var _controller1 = new TextEditingController();
  var _controller2 = new TextEditingController();
  var _controller3 = new TextEditingController();
  var _controller4 = new TextEditingController();

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        _controller1.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller1.value.text.length);

        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        _controller2.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller2.value.text.length);

        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _focusNode3.addListener(() {
      if (_focusNode3.hasFocus) {
        _controller3.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller3.value.text.length);

        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _focusNode4.addListener(() {
      if (_focusNode4.hasFocus) {
        _controller4.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller4.value.text.length);

        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _timer?.cancel();

    super.dispose();
  }

  Widget textFields() {
    double height = 60.0; //
    double width = MediaQuery.of(context).size.width / 6; //70.0;

    double fontSize = 24.0;

    var boxDecoration = BoxDecoration(
        color: ColorUtils.light_gray,
        borderRadius: BorderRadius.circular(10.0));

    var margin = EdgeInsets.all(8.0);

    int maxLength = 1;

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
          if (!(newVal.length <= maxLength)) {
            _controller1.text = newVal[newVal.length - 1];
          }

          if (newVal.length != 0) {
            setState(() {
              FocusScope.of(context).requestFocus(_focusNode2);
            });
          }
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
          if (!(newVal.length <= maxLength)) {
            _controller2.text = newVal[newVal.length - 1];
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode3);
          }
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
          if (!(newVal.length <= maxLength)) {
            _controller3.text = newVal[newVal.length - 1];
          }

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode4);
          }
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
          if (!(newVal.length <= maxLength)) {
            _controller4.text = newVal[newVal.length - 1];
          }

//          verifyInputs();
//
//          if (newVal.length != 0) {
//            FocusScope.of(context).requestFocus(_focusNode1);
//          }
        });

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          Container(
            height: height,
            width: width,
            margin: margin,
            decoration: boxDecoration,
            child: Center(child: firstTF),
          ),
          Container(
            height: height,
            width: width,
            margin: margin,
            decoration: boxDecoration,
            child: Center(child: secondTF),
          ),
          Container(
            height: height,
            width: width,
            margin: margin,
            decoration: boxDecoration,
            child: Center(child: thirdTF),
          ),
          Container(
            height: height,
            width: width,
            margin: margin,
            decoration: boxDecoration,
            child: Center(child: fourthTF),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Verification', style: TextStyle(fontSize: 32.0)),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                          'Enter the 4-digit code sent to ******${widget.phoneNumber.substring(7, widget.phoneNumber.length)}',
                          style: TextStyle(fontSize: 18.0)),
                      SizedBox(
                        height: 200.0,
                        child: Container(
                          child: Center(
                            child: Image.asset(
                              ImageUtils.otp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                        child: textFields(),
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: _resendOTP(context),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 24.0),
                          child: SizedBox(
                              width: double.maxFinite,
                              height: MarginUtils.buttonHeight,
                              child: _verify(context))),
                      _getErrorText(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _verify(context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : MaterialButton(
            onPressed: () async {
              if (validInput(context)) {
                showLoadingSnackBar();

                String otp =
                    "${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}";

                try {
                  var response =
                      await APIService().verifyOTP(widget.phoneNumber, otp);

                  showInSnackBar("verified");

                  if (response.newUser) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewUserScreen(authCode: response.authCode, phone: widget.phoneNumber)));
                  } else {

                    if(!widget.forgot){
                      bool reset = await showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Text("Account already exists\n\nIf you forgot your password, click reset below to set a new one"),
                          actions: <Widget>[
                            FlatButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text("RESET PASSWORD"),),
                            FlatButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("CANCEL")),
                          ],
                        ) ?? false;
                      });

                      if(!reset){
                        Navigator.of(context).pushNamedAndRemoveUntil(RoutUtils.login, (_) => false);
                        return;
                      }
                    }
                    //navigate to change pin page
                    print("authCode = ${response.authCode}");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(
                                authCode: response.authCode, phone: widget.phoneNumber)));
                  }
                } catch (e) {
                  print(e);

                  if(e == null || e.message == null || e.message.isEmpty) {
                    showInSnackBar(
                        "Error verifying code, please check your network and try again");
                  }else {
                    showInSnackBar(e.message);
                  }
                  return;

                  if (e.message != null && e.message.isNotEmpty) {
                    showInSnackBar("${e.message}");
                  } else {
                    showInSnackBar(
                        "Error verifying code, please check your network and try again");
                  }
                }
              } else {
                showInSnackBar('The code you entered is incomplete');
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

  bool validInput(context) {
    if (_controller1.text.isEmpty ||
        _controller2.text.isEmpty ||
        _controller3.text.isEmpty ||
        _controller4.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void _showErrorToast(context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        content: const Text(
          'The code you entered is incomplete',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _otpSendingFailed(context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        content: const Text(
          'Error sending verification code, please check your network and try again',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _otpSent(context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        content: Text(
          "Verification code sent to ${widget.phoneNumber}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _getErrorText() {
    if (errorOccured) {
      _timer = new Timer(const Duration(milliseconds: 4000), () {
        setState(() {
          errorOccured = false;
        });
      });

      return SizedBox(
        height: 24.0,
        child: Center(
          child: Text(
            "Verification failed!!! the code your entered is incorrect",
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

  Widget _resendOTP(context) {
    return otpLoading
        ? Center(child: CircularProgressIndicator())
        : FlatButton(
            onPressed: () {
              setState(() {
                otpLoading = true;
              });

              APIService().resendOTP(widget.phoneNumber).then((x) {
                if (x) {
//              otpErrorOccured = false;
                  _otpSent(context);
                } else {
//              otpErrorOccured = true;
                  _otpSendingFailed(context);
                }

                setState(() {
                  otpLoading = false;
                });
              });
            },
            child: Text(
              'Resend OTP',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          );
  }

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}

class OTPResponse {
  String authCode;
  bool newUser = false;
}
