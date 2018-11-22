import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';
import '../data_store/user_details.dart';
import '../utils/color_conts.dart';

class IceScreen extends StatefulWidget {
  @override
  _IceScreenState createState() => _IceScreenState();
}

class _IceScreenState extends State<IceScreen> {
  var _snackKey = GlobalKey<ScaffoldState>();

  var _loading = false;
  var _errorOccured = false;

  List<Contact> personalIce = [];
  List<Contact> cooperateIce = [];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() {
    setState(() {
      _loading = true;
    });

    LocalStorageHelper().getToken().then((token) {
      APIService().getIce(token).then((iceResponse) {
        if (iceResponse.statusCode != 200) {
          setState(() {
            _errorOccured = true;
          });

          return;
        }

        Map<String, dynamic> resBody = json.decode(iceResponse.body);
        print(resBody);

        List<dynamic> personalIceJsonList = resBody['userICEs'];
        List<dynamic> cooperateIceJsonList = resBody['organizationICEs'];

        print(personalIceJsonList);
        print(cooperateIceJsonList);

        for (Map<String, dynamic> ice in personalIceJsonList) {
          print(ice);
          personalIce.add(Contact.fromJson(ice));
        }

        for (Map<String, dynamic> ice in cooperateIceJsonList) {
          cooperateIce.add(Contact.fromJson(ice));
        }

        setState(() {
          _loading = false;
        });
      });
    });
  }

  void _showDialog() {
//    setState(() {
//      _saving_changes = false;
//      _show_error = false;
//    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AddICeDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _snackKey,
          backgroundColor: Colors.white,
          floatingActionButton: new FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              _showDialog();
            },
            tooltip: 'Increment',
            child: new Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'ICE',
              textAlign: TextAlign.left,
            ),
//            bottom: TabBar(
//              tabs: [
//                Tab(
//                  text: "Personal",
//                ),
//                Tab(
//                  text: "Cooperate",
//                ),
//              ],
//            ),
//          title: Text('Tabs Demo'),
          ),
          body: getLayout()),
    );
  }

  Widget getLayout() {
    if (_loading) {
      return Center(
          child: Container(
              height: 100.0, width: 100.0, child: CircularProgressIndicator()));
    } else if (_errorOccured) {
      return Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Error fetching data from server, please check your network and click retry",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "[If problem persists, please logout and login again]",
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButton(
                onPressed: (() {
                  fetchData();
                }),
                child: Text(
                  "RETRY",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      );
    } else {
      if (personalIce.isEmpty && cooperateIce.isEmpty) {
        return Container(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You have not added an ICE yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Text(
                  "[Tap on the + button to add ICEs]",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        );
      }
      return _IceContactList();
    }
  }

  Widget _IceContactList() {
    return ListView(
      children: [
        Container(
            color: ColorUtils.light_gray,
            padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
            child: Text(
              'PERSONAL ICE',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )),
        _ListView(personalIce),
        Container(
            color: ColorUtils.light_gray,
            padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
            child: Text(
              'COOPERATE ICE',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )),
        _ListView(cooperateIce),
      ],
    );
  }
}

Widget _tabbar() {
  return TabBarView(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              color: ColorUtils.light_gray,
              padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
              child: Text(
                'PERSONAL ICE',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              )),
          _ListView(allContacts),
        ],
      ),

      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              color: ColorUtils.light_gray,
              padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
              child: Text(
                'COOPERATE ICE',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              )),
          _ListView(allContacts),
        ],
      )

//            Icon(Icons.directions_bike),
    ],
  );
}

Widget _ListView(List<Contact> contactList) {
  return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: contactList.length,
      itemBuilder: (BuildContext content, int index) {
        Contact contact = contactList[index];

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        contact.name[0],
                        style: TextStyle(fontSize: 20.0, color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          contact.name,
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        Text(
                          contact.phoneNumber,
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0),
                height: 0.5,
                color: Colors.grey,
              ),
            ],
          ),
        );
      });
}

class AddICeDialog extends StatefulWidget {
  AddICeDialog({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddICeDialogState createState() => _AddICeDialogState();
}

class _AddICeDialogState extends State<AddICeDialog> {
  final _formKey = GlobalKey<FormState>();

  String _selectedId;

  var _phone = "";
  var _name = "";

  var _errorMessage =
      "Error saving changes, please check your network and try again";

  var _saving_changes = false;
  var _show_error = false;

  _AddICeDialogState() {}

  Widget _showError() {
    return _show_error
        ? Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          )
        : Container();
  }

  final nameTFController = TextEditingController();
  final phoneTFController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameTFController.dispose();
    phoneTFController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
//      title: new Text("New Dialog"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  onSaved: (value) {
                    _name = value;
                  },
                  controller: nameTFController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please a valid name';
                    }
                  },
                ),
                Container(margin: EdgeInsets.all(8.0)),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  controller: phoneTFController,
                  onSaved: (value) {
                    _phone = value;
                  },
                  validator: (value) {
                    if (value.length != 11) {
                      return 'Please a valid phone number';
                    }
                  },
                ),
                Container(margin: EdgeInsets.all(8.0)),
                _showError()
              ],
            ),
          ),
        ),

//        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new FlatButton(
              child: new Text(
                "CANCEL",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            _saveChanges(),
          ],
        )
      ],
    );
  }

  var _snackKey = GlobalKey<ScaffoldState>();
  Widget _saveChanges() {
    return _saving_changes
        ? Center(child: CircularProgressIndicator())
        : FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setState(() {
                  _saving_changes = true;
                });

                LocalStorageHelper().getToken().then((token) {
                  if (token.isEmpty) {
                    //error

                    setState(() {
                      _saving_changes = false;
                    });
                  } else {
                    print(token);

                    APIService.getInstance()
                        .saveIce(_name, _phone, token)
                        .then((body) {
                      _saving_changes = false;
                      _show_error = true;

                      print(body);
                      setState(() {
                        _errorMessage = body["message"];
                      });
                      //done
                    });
                  }
                });
              }
            },
            child: Text(
              'SAVE CHANGES',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            textColor: Colors.white,
          );
  }
}

class Contact {
  String id;
  String name;
  String phoneNumber;
  bool paused;
  int dateAdded;

  Contact.fromJson(Map<String, dynamic> info)
      : id = info.containsKey("id") ? info["id"] : "",
        name = info.containsKey("name") ? info["name"] : "",
        phoneNumber =
            info.containsKey("phoneNumber") ? info["phoneNumber"] : "",
        paused = info.containsKey("paused") ? info["paused"] : false,
        dateAdded = info.containsKey("dateAdded") ? info["dateAdded"] : 0;
}

class ContactListTile extends ListTile {
  static var diameter = 50.0;
  static var backgroundColor = Colors.black;

  ContactListTile(Contact contact)
      : super(
            title: Text(
              contact.name,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              contact.phoneNumber,
              style: TextStyle(color: Colors.grey),
            ),
            leading: Container(
              width: diameter,
              height: diameter,
              decoration: new BoxDecoration(
                // Circle shape
                shape: BoxShape.circle,
//          color: backgroundColor,
                // The border you want
                border: new Border.all(
                  width: 2.0,
                  color: Colors.grey,
                ),
                // The shadow you want
              ),
              child: Center(
                child: Text(
                  contact.name[0],
                  style: TextStyle(fontSize: 24.0, color: Colors.grey),
                ),
              ),
            ));
}

List<Contact> allContacts = [
//  Contact(name: 'Isa Tusa', phoneNumber: 'isa.tusa@me.com'),
//  Contact(name: 'Racquel Ricciardi', phoneNumber: 'racquel.ricciardi@me.com'),
//  Contact(name: 'Teresita Mccubbin', phoneNumber: 'teresita.mccubbin@me.com'),
//  Contact(name: 'Rhoda Hassinger', email: 'rhoda.hassinger@me.com'),
//  Contact(name: 'Carson Cupps', email: 'carson.cupps@me.com'),
//  Contact(name: 'Devora Nantz', email: 'devora.nantz@me.com'),
//  Contact(name: 'Tyisha Primus', email: 'tyisha.primus@me.com'),
];
