import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/scopped_model/user_scopped_model.dart';
import '../utils/color_conts.dart';
import '../utils/image_utils.dart';
import '../utils/margin_utils.dart';
import '../utils/routes_utils.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
//  final userModel = UserModel();

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

  AppStateProvider appStateProvider;

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);

    return Scaffold(
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
    );
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
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: userModel.getUserData().picture.isNotEmpty
                ? Container(
                    height: 100.0,
                    width: 100.0,
                    /*child: FadeInImage(
                      placeholder: AssetImage(ImageUtils.person_avatar),
                      image: CachedNetworkImageProvider(
                          userModel.getUserData().picture),
                    ),*/
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1.0),
                        image: DecorationImage(
                            image:
                                /*AdvancedNetworkImage(
                                userModel.getUserData().picture,
                                useDiskCache: true)*/
                                CachedNetworkImageProvider(
                                    userModel.getUserData().picture),
                            fit: BoxFit.cover)),
                  )
                : Container(
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
          "${userModel.getUserData().firstName} ${userModel.getUserData().lastName}"
              .replaceAll(RegExp(r'[^\w\s]+'), ''),
//          userModel.getUserData().firstName,
//          _name,
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
                  appStateProvider.user.email,
//                  _email,
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
                  "*****",
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
                  'SECLOT ID',
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
                      appStateProvider.user.seclotId.toString(),
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
                  'LAST KNOWN LOCATION',
                  style: TextStyle(fontSize: _labelSize, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  2.0,
                ),
                child: Text(
                  "${appStateProvider.user.latitude} ${appStateProvider.user.longitude}",
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
}
