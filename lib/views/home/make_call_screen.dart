import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/utils/color_conts.dart';

class MakeCallScreen extends StatefulWidget {
  @override
  _MakeCallScreenState createState() => _MakeCallScreenState();
}

class _MakeCallScreenState extends State<MakeCallScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  bool otpLoading = false;
  bool errorOccured = false;
  bool otpErrorOccured = false;
  Timer _timer;

  var _focusNode1 = new FocusNode();
  var _focusNode2 = new FocusNode();
  var _focusNode3 = new FocusNode();
  var _focusNode4 = new FocusNode();
  var _focusNode5 = new FocusNode();

  var _controller1 = new TextEditingController();
  var _controller2 = new TextEditingController();
  var _controller3 = new TextEditingController();
  var _controller4 = new TextEditingController();
  var _controller5 = new TextEditingController();

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      if (!cancel) {
        _makeCall();
      }
      Navigator.of(context).pop();
    });

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

    _focusNode4.addListener(() {
      if (_focusNode5.hasFocus) {
        _controller5.selection = TextSelection(
            baseOffset: 0, extentOffset: _controller5.value.text.length);

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
    _controller5.dispose();
    _timer?.cancel();

    super.dispose();
  }

  bool cancel = false;
  AppStateProvider appStateProvider;

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);

//    Future.delayed(Duration.zero, () => showDialog(context: context,
////        barrierDismissible: false,
//
//        builder: (context) => EnterPinDialog())
//    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sending...",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(height: 16),
            Center(
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Material(
                elevation: 16.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Text("Enter pin to stop message"),
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: textFields(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textFields() {
    double height = 50.0; //
    double width = MediaQuery.of(context).size.width / 8; //70.0;

    double fontSize = 16.0;

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

          if (newVal.length != 0) {
            FocusScope.of(context).requestFocus(_focusNode5);
          }
        });

    var fifthTF = new TextField(
        focusNode: _focusNode5,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: new TextStyle(fontSize: fontSize, color: Colors.black),
        controller: _controller5,
        onChanged: (newVal) {
          if (!(newVal.length <= maxLength)) {
            _controller5.text = newVal[newVal.length - 1];
          }

          if (validInput(context)) {
            var enteredPins =
                "${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}${_controller5.text}";
            print("ENTERED PIN => $enteredPins");
            var reversedPin = enteredPins.split("").reversed.join("");
            print("REVERSED PIN => $reversedPin");
            if (reversedPin == appStateProvider.password) {
              print("CANCEL CALL");
              cancel = true;
            }
          }
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
          Container(
            height: height,
            width: width,
            margin: margin,
            decoration: boxDecoration,
            child: Center(child: fifthTF),
          ),
        ],
      ),
    );
  }

  bool validInput(context) {
    if (_controller1.text.isEmpty ||
        _controller2.text.isEmpty ||
        _controller3.text.isEmpty ||
        _controller4.text.isEmpty ||
        _controller5.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  _makeCall() {
    appStateProvider.sendNotification();
    APIService.getInstance()
        .sendDistressCall(appStateProvider.token)
        .then((response) {
      print(response);
    }).catchError((error) {
      print(error);
    });
  }
}
