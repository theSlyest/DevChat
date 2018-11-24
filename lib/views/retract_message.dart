import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';
import '../utils/color_conts.dart';

class RetractScreen extends StatefulWidget {
  @override
  _RetractScreenState createState() => _RetractScreenState();
}

class _RetractScreenState extends State<RetractScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.light_gray,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Retract message',
            textAlign: TextAlign.left,
          ),
        ),

        body: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Center(
            child: Image.asset(ImageUtils.retract_message),
          ),
        ),

        // _ListView(),
      ),
    );
  }
}
