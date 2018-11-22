import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seclot/utils/image_utils.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:seclot/utils/routes_utils.dart';
import '../utils/color_conts.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
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
            'Subscription',
            textAlign: TextAlign.left,
          ),
        ),

        body: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: ListView(
            children: <Widget>[

              Padding(padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
              child: Text('SUBSCRIPTIONS'),),

              SizedBox(
                height: 100.0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[

                      SizedBox(width: 50.0,
                        height: 50.0,
                        child: Image.asset(ImageUtils.bronze_indicator, fit: BoxFit.fitHeight,),
                      ),

                      SizedBox(width: 20.0,),

                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('BRONZE', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),

                          SizedBox(height: 5.0,),

                          Text('#50,000/MONTH')
                        ],
                      )),

                      SizedBox(width: 20.0,),

                      new RaisedButton(
                          child: new Text("VIEW", style: TextStyle(fontSize: 16.0, color: Colors.white),),
                          color: Colors.black,
                          onPressed: () {Navigator.pushNamed(context, RoutUtils.wallet);},
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0))
                      )

                    ],
                  ),
                ),
              )


            ],
          ),
        ),
        // _ListView(),
      ),
    );
  }
}
