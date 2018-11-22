import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';
import '../utils/color_conts.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Payment',
            textAlign: TextAlign.left,
          ),
        ),

        body: Container(
          margin: EdgeInsets.only(top: 50.0),
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'SUBSCRIPTION NAME',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'BRONZE',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'PRICE',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '14\$',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'START DATE',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '14 August 2018',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'END DATE',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '14 August 2019',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100.0,
              ),
              Text('  PAYMENT METHOD'),
              SizedBox(
                height: 250.0,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 300.0,
                      height: 250.0,
                      child: Image.asset(ImageUtils.visa_card_image),
                    ),
                    Container(
                      width: 300.0,
                      height: 250.0,
                      child: Image.asset(
                        ImageUtils.visa_card_image,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              SizedBox(
                  width: double.maxFinite,
                  height: MarginUtils.buttonHeight,
                  child: RaisedButton(
                      color: Colors.black,
                      onPressed: () {
//                    Navigator.pushNamed(context, RoutUtils.home);
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ))),
            ],
          ),
        ),

        // _ListView(),
      ),
    );
  }
}
