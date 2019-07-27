import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_places_dialog/flutter_places_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/views/widget/ui_snackbar.dart';
import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../model/user.dart';
import '../utils/color_conts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CreateProfileScreen extends StatefulWidget {
  final bool newUser;
  final Map<String, dynamic> info;

//  const OTPScreen({this.phoneNumber});
  const CreateProfileScreen({Key key, this.newUser = false, this.info})
      : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen>  with UISnackBarProvider {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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


  var _icon_size = 24.0;
  var location = new Location();

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


  @override
  void initState() {
    FlutterPlacesDialog.setGoogleApiKey(
        "AIzaSyCV7tym2ZRSxOvDKoB19Q6tdnzw0t9wgqQ");
//        "AIzaSyAMttZPl6ZHtz56c3eLIFiy-5Z_wZYekPY"
////        "AIzaSyDwbZW8HVXFZvj_6LfEaSZwWfshqzkoU2w"
//        );
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


    APIService().updateProfileImage(appStateProvider.token, image, (success, response) {
      if (success) {
        uploadError = false;
        showToast("Picture updated");
      } else {
        uploadError = true;
        showToast(
            "Error updating pic, please check your network and try again");
      }

      setState(() {
        imageUploading = false;
      });
    });

//    LocalStorageHelper().getToken().then((token) {
//
//    });
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

  AppStateProvider appStateProvider;

  @override
  Widget build(BuildContext context) {
    appStateProvider = Provider.of<AppStateProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
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
    return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                imageView(),
                firstName(),
                lastName(),
                email(),
                pin(),
//                phone(),
                referealId(),
//                address(),
//                selectSector(),
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
                ? appStateProvider.user.picture.isNotEmpty
                    ? Stack(children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                        imageUrl: appStateProvider.user.picture,
                                        fit: BoxFit.cover),
                                    Align(
                                        alignment: Alignment.center,
                                        child: getAddButton()),
                                  ],
                                ),
                              ),
                            ])
                      ])
                    : Center(
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
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
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

  Widget firstName() {
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
              initialValue: appStateProvider.user.firstName,
              onSaved: (value){
                _firstName = value;
              },
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
              decoration: InputDecoration(
                labelText: 'First Name',
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

  Widget lastName() {
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
              initialValue: appStateProvider.user.lastName,
              onSaved: (value){
                _lastName = value;
              },
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
              decoration: InputDecoration(
                labelText: 'Last Name',
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
    _emailController.text = appStateProvider.user.email;

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
              labelText: 'Email',
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
                labelText: 'Pin',
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
            node: FocusScopeNode(),
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

    _referealIdController.text = appStateProvider.user.referralId;
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
                        child: getReferalTextField(),
                      ),
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

  Widget getReferalTextField() {

    return _referealIdController.text.isEmpty
        ? TextFormField(
            controller: _referealIdController,
            onSaved: (value) {
              _referalID = value;
            },
            style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
          )
        : FocusScope(
            node: FocusScopeNode(),
            child: TextFormField(
              controller: _referealIdController,
              onSaved: (value) {
                _referalID = value;
              },
              style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
            ),
          );
  }

  Widget address() {
    _addressController.text = "${appStateProvider.user.address}(Lat: ${appStateProvider.user.latitude}, Lon: ${appStateProvider.user.longitude})";
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
      _addressController.text = "(Lat: ${place.location.latitude}, Lon: ${place.location.longitude})";
    } on PlatformException {
      place = null;
    } catch (error) {
      print("Error");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // print("$place");

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
    return MaterialButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                showLoadingSnackBar();

                var user = UserDTO();
                user.firstName = _firstName;
                user.lastName = _lastName;
                user.email = _emailController.text;

            /*    if (_place != null) {
                  user.latitude = _place.location.latitude;
                  user.longitude = _place.location.longitude;
                }*/

                if (_referealIdController.text.isNotEmpty &&
                    user.referralId.isEmpty) {
                  user.referralId = _referealIdController.text;
                }

                try{
                  var res = await APIService.getInstance().updateUser(appStateProvider.token, user);
                  showInSnackBar("Changes saved");

//                  appStateProvider.user = res;
                  var userAndToken = UserAndToken();
                  userAndToken.user = res;
                  userAndToken.token = appStateProvider.token;
                  userAndToken.token = appStateProvider.password;

                  appStateProvider.saveDetails(userAndToken);
                  appStateProvider.user = res;


                }catch(err){

                  if(err == null || err.message == null || err.message.isEmpty) {
                    showInSnackBar("Error, please check your network and try again");
                  }else{
                    showInSnackBar(err.message);
                  }

                }

              } else {
                showInSnackBar("Please ensure filled all fields properly");

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

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
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
