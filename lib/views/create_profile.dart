import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../data_store/user_details.dart';
import '../model/user.dart';
import '../utils/color_conts.dart';

class CreateProfileScreen extends StatefulWidget {
  final bool newUser;
  final Map<String, dynamic> info;

//  const OTPScreen({this.phoneNumber});
  const CreateProfileScreen({Key key, this.newUser = false, this.info})
      : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  var _loading = true;

  double _width;
  File _image;

  final inputFontStyle = 18.0;
  final inputLabel = 16.0;
  final inputSeperator = 20.0;

  var _firstName;
  var _lastName;
  var _pin;
  var _phone;

  var _emailF;
  var _addressF;
  var _referalID;

  var _latitude = "";
  var _longitude = "";

  var spacing = EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0);

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _referealIdController = TextEditingController();
  final _sectorController = TextEditingController();
  var _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _icon_size = 24.0;
  UserDTO user = null;

  bool _saving_changes = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _referealIdController.dispose();
    _sectorController.dispose();

    super.dispose();
  }

  void _fetchData() {
    this.user = UserDetails().getUserData();

    print(user.toFullJson());

    String s = "${user.firstName} ${user.lastName}";
    s = s.replaceAll("\t", '');
    setState(() {
      _nameController.text = s;
      _referealIdController.text = "${user.seclotId}";
      _emailController.text = "${user.email}";

      _addressController.text = "${user.latitude}, ${user.longitude}";

      if (!(user.latitude == 0.0) && !(user.longitude == 0.0)) {
        print("LOCATION DATA => ${user.latitude}, ${user.longitude}");
      }

      _loading = false;
    });
  }

  @override
  void initState() {
    FlutterPlacesDialog.setGoogleApiKey(
        "AIzaSyBRTlfkTgxhu0f5-GovEpKviJUDyfqyEv8");
    _fetchData();
  }

  void _getPhone() {
    LocalStorageHelper().getPhon().then((phone) {
      setState(() {
        _phoneNumberController.text = phone;
      });
    });
  }

  Future _getImage({ImageSource imageSource}) async {
    var image = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      _image = image;
      uploadImage(image);
    });
  }

  var imageUploading = false;
  var uploadError = false;
  void uploadImage(File image) {
    setState(() {
      imageUploading = true;
    });

    LocalStorageHelper().getToken().then((token) {
      APIService().updateImage(token, image).then((response) {
        if (response.isEmpty) {
          uploadError = false;
        } else {
          uploadError = false;
        }

        setState(() {
          imageUploading = false;
        });
      });
    });
  }

  Widget getAddButton() {
    if (imageUploading) {
      return Container(
        child: CircularProgressIndicator(),
      );
    } else if (uploadError) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  uploadImage(_image);
                }),
            SizedBox(
              height: 4.0,
            ),
            Text(
              'Retry',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ]);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 40.0,
              ),
              onPressed: _showImagePickerDialog),
          SizedBox(
            height: 4.0,
          ),
          Text(
            'Change image',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Profile update",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      body: SafeArea(child: _getView()),
    );
  }

  Widget _getView() {
    return _loading
        ? Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
              FlatButton(
                onPressed: (() {}),
//              child: Text("Cancel", style: TextStyle(),)
              )
            ],
          )
        : Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                imageView(),
                name(),
                email(),
                pin(),
//                phone(),
                referealId(),
                address(),
                selectSector(),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _saveChanges(),
                )
              ],
            ),
          );
  }

  Widget imageView() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            height: 300.0,
            color: Colors.black,
            child: _image == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            onPressed: _showImagePickerDialog),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Upload Photo',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Expanded(
                              child: Stack(
                                children: <Widget>[
                                  Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: getAddButton()),
                                ],
                              ),
                            ),
                          ]),

//                    Align(
//
//                        alignment: Alignment.bottomLeft,
//                        child: Padding(
//                          padding: const EdgeInsets.all(16.0),
//                          child: Container(
//                              color: Colors.black.withOpacity(0.5),
//                              child: Text("$_firstName $_lastName",
//                                style: TextStyle(color: Colors.white,
//                                    fontSize: 24.0),)
//                          ),
//                        )
//                    ),
                    ],
                  )),
      ],
    );
  }

  Widget name() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Expanded(
              child: FocusScope(
            node: new FocusScopeNode(),
            child: TextFormField(
              controller: _nameController,
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
              decoration: InputDecoration(
                labelText: 'NAME',
                labelStyle: TextStyle(
                  fontSize: inputFontStyle,
                ),
                hintStyle: TextStyle(
                  fontSize: inputLabel,
                  height: 1.5,
                ),
              ),
              autofocus: true,
//          keyboardType: TextInputType.phone,
            ),
          )),
        ],
      ),
    );
  }

  Widget email() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.email,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Expanded(
              child: TextFormField(
            controller: _emailController,
            validator: validateEmail,
            onSaved: (value) {
              _emailF = value;
            },
            style: TextStyle(fontSize: 18.0, color: Colors.black54),
            decoration: InputDecoration(
              labelText: 'EMAIL',
              labelStyle: TextStyle(
                fontSize: inputFontStyle,
              ),
              hintStyle: TextStyle(
                fontSize: inputLabel,
                height: 1.5,
              ),
            ),
            autofocus: true,
//          keyboardType: TextInputType.phone,
          )),
        ],
      ),
    );
  }

  Widget pin() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.lock,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Expanded(
              child: FocusScope(
            node: new FocusScopeNode(),
            child: TextFormField(
              initialValue: "12345",
              obscureText: true,
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
              decoration: InputDecoration(
                labelText: 'PIN',
                labelStyle: TextStyle(
                  fontSize: inputFontStyle,
                ),
                hintStyle: TextStyle(
                  fontSize: inputLabel,
                  height: 1.5,
                ),
              ),
              autofocus: true,
//          keyboardType: TextInputType.phone,
            ),
          )),
        ],
      ),
    );
  }

  Widget phone() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.perm_contact_calendar,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Expanded(
              child: FocusScope(
            node: new FocusScopeNode(),
            child: TextFormField(
              controller: _phoneNumberController,
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
              decoration: InputDecoration(
                labelText: 'PHONE',
                labelStyle: TextStyle(
                  fontSize: inputFontStyle,
                ),
                hintStyle: TextStyle(
                  fontSize: inputLabel,
                  height: 1.5,
                ),
              ),
              autofocus: true,
//          keyboardType: TextInputType.phone,
            ),
          )),
        ],
      ),
    );
  }

  Widget referealId() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.perm_contact_calendar,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _referealIdController,
                          onSaved: (value) {
                            _referalID = value;
                          },
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Referal ID',
                            labelStyle: TextStyle(
                              fontSize: inputFontStyle,
                            ),
                            hintStyle: TextStyle(
                              fontSize: inputLabel,
                              height: 1.5,
                            ),
                          ),
                          autofocus: true,
//          keyboardType: TextInputType.phone,
                        ),
                      ),
                      FlatButton(
                          onPressed: _copyReferal,
                          child: Text(
                            "copy",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0),
                          ))
                    ],
                  ),
                  Divider(
                    height: 3.0,
                    color: Colors.black,
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget address() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FocusScope(
                node: new FocusScopeNode(),
                child: TextFormField(
                  controller: _addressController,
//                      validator: validateAddress,
                  onSaved: (value) {
                    _referalID = value;
                  },
                  style: TextStyle(fontSize: 18.0, color: Colors.black54),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      fontSize: inputFontStyle,
                    ),
                  ),
                  autofocus: true,
//          keyboardType: TextInputType.phone,
                ),
              ),
              GestureDetector(
                onTap: _view_map,
                child: Text(
                  "View Map",
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                height: 3.0,
                color: Colors.black,
              )
            ],
          )),
        ],
      ),
    );
  }

  Widget selectSector() {
    return Padding(
      padding: spacing,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.perm_contact_calendar,
            size: _icon_size,
            color: ColorUtils.dark_gray,
          ),
          SizedBox(
            width: inputSeperator,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Text(
                "SECTOR",
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
//                  SizedBox(height: 3.0,),
              FlatButton(
                  onPressed: _view_map,
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 0.0),
                  child: Text(
                    "Select sector to be notified",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  )),

//                  SizedBox(height: 3.0,),
              Divider(
                height: 3.0,
                color: Colors.black,
              )
            ],
          )),
        ],
      ),
    );
  }

  String validateAddress(String value) {
    if (value.length < 1)
      return 'Please select your location from the map';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid email';
    else
      return null;
  }

  // user defined function

  void _showLocationPicker() {
//    setState(() {_locationPickerData = result.toString();});
  }

  void _showImagePickerDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new RaisedButton.icon(
                shape: StadiumBorder(),
                icon: Icon(Icons.photo),
                label: new Text(
                  "GALLERY",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _getImage(imageSource: ImageSource.gallery);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              new RaisedButton.icon(
                shape: StadiumBorder(),
                icon: Icon(Icons.photo_camera),
                label: new Text(
                  "CAMERA",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _getImage(imageSource: ImageSource.camera);
                },
              ),
            ],
          ),
          title: new Text(
            "Select from",
            textAlign: TextAlign.center,
          ),

//          content: new Text("Alert Dialog body"),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//
//          ],
        );
      },
    );
  }

  void _copyReferal() {
    Clipboard.setData(new ClipboardData(text: _referealIdController.text));
  }

  void _view_map() {
    _showPlacePicker();
  }

  PlaceDetails _place;
  // Platform messages are asynchronous, so we initialize in an async method.
  _showPlacePicker() async {
    PlaceDetails place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await FlutterPlacesDialog.getPlacesDialog();
    } on PlatformException {
      place = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print("$place");

//    _addressController.text = place.address;
//    _latitude = place.location.latitude as String;
//    _longitude = place.location.longitude as String;
    setState(() {
//      _addressController.text = place.address;
      _place = place;
      _addressController.text =
          "${_place.location.latitude}, ${_place.location.longitude}";
    });
  }

  getAddress(double latitude, double longitude) {}

  Widget _saveChanges() {
    return _saving_changes
        ? Center(child: CircularProgressIndicator())
        : MaterialButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

//                if (_addressController.text.length < 3) {
//                  showToast("Please select your address from the map");
//                  return;
//                }

                setState(() {
                  _saving_changes = true;
                });

                //fetch all fields
                //update profile

                LocalStorageHelper().getToken().then((token) {
                  user = UserDTO();
                  user.email = _emailController.text;
//                  user.address = _addressController.text;

                  var address = _addressController.text;
                  user.latitude = _place.location.latitude;
                  user.longitude = _place.location.longitude;

                  print("UPDATE PROFILE PRESSED");

                  APIService.getInstance().updateUser(token, user).then((bool) {
                    if (bool) {
                      print("SUCCESS");

                      _fetchData();
                      showToast("Changes saved");
                    } else {
                      print("FAILURE");
                      showToast(
                          "Error occured while saving changes, please check your network and try again");
                    }

                    setState(() {
                      _saving_changes = false;
                    });
                  });
                });

//          Future.delayed(Duration(seconds: 3), () {
//            setState(() {
//              _saving_changes = false;
//            });
//          });

//                      Navigator.of(context)
//                          .pushNamedAndRemoveUntil(RoutUtils.home,
//                              (Route<dynamic> route) => false);

              } else {
                setState(() {
                  _saving_changes = false;
                });
              }
            },
            elevation: 8.0,
//                  splashColor: Colors.white,
            minWidth: double.infinity,
            height: 48.0,
            color: Colors.black,
            child: Text(
              'SAVE CHANGES',
              style: TextStyle(fontSize: 16.0),
            ),
            textColor: Colors.white,
          );
  }

  void showToast(String message) {
    /* final snackBar = SnackBar(
        content: Text(message),
    action: SnackBarAction(
    label: 'Close',
    onPressed: () {
    // Some code to undo the change!
    },
    ),);*/

//    Scaffold.of(context).showSnackBar(snackBar);
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 4,
//        bgcolor: "#e74c3c",
//        textcolor: '#ffffff'
    );
  }
}

/**
 * CENTER = none
    CENTER_CROP = Cover
    CENTER_INSIDE = scaleDown
    FIT_CENTER = contain (alignment.center)
    FIT_END = contain (alignment.bottomright)
    FIT_START = contain (alignment.topleft)
    FIT_XY = Fill
 */
