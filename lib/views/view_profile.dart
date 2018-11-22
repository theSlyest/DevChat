import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import '../data_store/user_details.dart';
import '../utils/color_conts.dart';
import '../utils/image_utils.dart';
import '../utils/margin_utils.dart';
import '../utils/routes_utils.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var _image;
  String _email = "Not set";
  String _name = "Not set";
  String _pin = "*******";
  String _phone = "Not set";
  String _referal_id = "Not set";
  String _address = "Not set";

  var _iconSize = 24.0;
  var _labelSize = 14.0;
  var _inputSize = 16.0;
  var _horizontalSeparator = Container(
    margin: EdgeInsets.only(right: 24.0, top: 16.0, bottom: 16.0),
//    padding: EdgeInsets.only(right: 32.0),
    color: Colors.grey,
    height: 1.0,
  );

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Widget imageView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              child: Image.asset(ImageUtils.person_avatar),
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3.0)),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          _name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.0),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget email() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 2.0,
            left: 16.0,
            right: 24.0,
          ),
          child: Icon(
            Icons.email,
            size: _iconSize,
            color: ColorUtils.dark_gray,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  'EMAIL',
                  style: TextStyle(fontSize: _labelSize, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  _email,
                  style: TextStyle(
                      fontSize: _inputSize, color: ColorUtils.dark_gray),
                  softWrap: true,
                ),
              ),
              _horizontalSeparator
            ],
          ),
        ),
      ],
    );
  }

  Widget pin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 2.0,
            left: 16.0,
            right: 24.0,
          ),
          child: Icon(
            Icons.lock,
            size: _iconSize,
            color: ColorUtils.dark_gray,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  'PIN',
                  style: TextStyle(fontSize: _labelSize, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  _pin,
                  style: TextStyle(
                      fontSize: _inputSize, color: ColorUtils.dark_gray),
                  softWrap: true,
                ),
              ),
              _horizontalSeparator
            ],
          ),
        ),
      ],
    );
  }

  Widget phone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 2.0,
            left: 16.0,
            right: 24.0,
          ),
          child: Icon(
            Icons.perm_contact_calendar,
            size: _iconSize,
            color: ColorUtils.dark_gray,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  'PHONE',
                  style: TextStyle(fontSize: _labelSize, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  _phone,
                  style: TextStyle(
                      fontSize: _inputSize, color: ColorUtils.dark_gray),
                  softWrap: true,
                ),
              ),
              _horizontalSeparator
            ],
          ),
        ),
      ],
    );
  }

  Widget referalId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 2.0,
            left: 16.0,
            right: 24.0,
          ),
          child: Icon(
            Icons.perm_contact_calendar,
            size: _iconSize,
            color: ColorUtils.dark_gray,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  'REFERAL ID',
                  style: TextStyle(fontSize: _labelSize, color: Colors.grey),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(
                      2.0,
                    ),
                    child: Text(
                      _referal_id,
                      style: TextStyle(
                          fontSize: _inputSize, color: ColorUtils.dark_gray),
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Clipboard.setData(new ClipboardData(text: _referal_id));
                      },
                      child: Text(
                        'copy',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                      padding: EdgeInsets.all(0.0),
                    ),
                  )
                ],
              ),
              _horizontalSeparator,
            ],
          ),
        ),
      ],
    );
  }

  Widget address() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 2.0,
            left: 16.0,
            right: 24.0,
          ),
          child: Icon(
            Icons.location_on,
            size: _iconSize,
            color: ColorUtils.dark_gray,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  'ADDRESS',
                  style: TextStyle(fontSize: _labelSize, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  _address,
                  style: TextStyle(
                      fontSize: _inputSize, color: ColorUtils.dark_gray),
                  softWrap: true,
                ),
              ),
              _horizontalSeparator,
            ],
          ),
        ),
      ],
    );
  }

  Widget editProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          margin: EdgeInsets.only(bottom: 24.0),
          child: SizedBox(
              width: double.maxFinite,
              height: MarginUtils.buttonHeight,
              child: RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, RoutUtils.create_profile);
                  },
                  child: Text(
                    'Edit profile',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              imageView(),
              Padding(
                padding: EdgeInsets.all(16.0),
              ),
              email(),
              pin(),
//              phone(),
              referalId(),
              address(),
              editProfile(),
            ],
          ),
        ),
      ),
    );
  }

  void getData() {
//    LocalStorageHelper().getPhon()
//        .then((phone){
//      setState(() {
//        _phone = phone;
//      });
//    });
//
//    var userInfo  = UserInfo.getInstance();
//    var profile = userInfo.getProfile();

    var profile = UserDetails().getUserData();

    setState(() {
      _name = "${profile.firstName} ${profile.lastName}";
      _email = profile.email;
      _pin = "*******";
      _referal_id = profile.seclotId.toString();
    });
  }
}
