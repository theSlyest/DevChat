import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/model/ice.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import '../utils/color_conts.dart';

class IceScreen extends StatefulWidget {
  @override
  _IceScreenState createState() => _IceScreenState();
}

class _IceScreenState extends State<IceScreen> {
  var _snackKey = GlobalKey<ScaffoldState>();

  AppStateProvider appState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
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
        ),
        body: (appState.ice.personalIce.isEmpty &&
                appState.ice.cooperateIce.isEmpty)
            ? Container(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "You have not added an ICE yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
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
              )
            : _IceContactList(appState.ice));
  }

  Widget _IceContactList(IceDAO iceDao) {
    return ListView(
      children: [
        Container(
            color: ColorUtils.light_gray,
            padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
            child: Text(
              'PERSONAL ICE',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )),
        _ListView(iceDao.personalIce),
        Container(
            color: ColorUtils.light_gray,
            padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
            child: Text(
              'COOPERATE ICE',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )),
        _ListView(iceDao.cooperateIce),
      ],
    );
  }

  Widget _ListView(List<IceDTO> contactList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: contactList.length,
        itemBuilder: (BuildContext content, int index) {
          IceDTO contact = contactList[index];

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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              contact.name,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                            Text(
                              contact.phoneNumber,
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        getPausedIconButton(contact),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: (() {
                              _showConfrimDeleteDialog(contact);
                            })),
                      ],
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

  Widget getPausedIconButton(IceDTO ice) {
    return ice.paused
        ? IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: (() {
              resumeIce(ice);
            }))
        : IconButton(
            icon: Icon(Icons.pause),
            onPressed: (() {
              _showConfirmPauseDialog(ice);
            }));
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AddICeDialog(appState);
        });
  }

  Future resumeIce(IceDTO ice) async {
    try {
      var ices = await APIService()
          .updateIce(iceId: ice.id, pause: false, token: appState.token);
      appState.updateIce = ices;
    } catch (e) {
//                  _errorMessage = json.decode(response.body)['message'];
//      _errorMessage =
//      "Error saving changes, check your internet and try again";
//      setState(() {
//        _show_error = true;
//      });
      print(e);
    }
  }

  var pausing = false;
  var pauseError = "";

  void _showConfirmPauseDialog(IceDTO ice) {
    setState(() {
      pausing = false;
      pauseError = "";
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              title: Text("PAUSE THIS ICE"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Are you sure you want to pause this ICE? "
                      "\nThey will no longer get notified whenever you issue a call"),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      pauseError,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                          child: Text("CANCEL")),
                      pauseButton(ice)
                    ],
                  ),
                )
              ]);
        });
  }

  Widget pauseButton(IceDTO ice) {
    return pausing
        ? CircularProgressIndicator()
        : RaisedButton(
            onPressed: (() async {
              setState(() {
                pausing = true;
              });

              /*  APIService()
              .updateIce(iceId: ice.id, pause: true, token: _token)
              .then((response) {
            setState(() {
              pausing = false;
            });
            print("HANDLING RESPONSE");

            iceBloc.setIce(response);
          });*/

              try {
                var ices = await APIService().updateIce(
                    iceId: ice.id, pause: true, token: appState.token);
                appState.updateIce = ices;
              } catch (e) {
                print(e);
              }

              setState(() {
                pausing = false;
              });
            }),
            child: Text("PAUSE ICE"),
            color: Colors.black,
            textColor: Colors.white);
  }

  var deleting = false;
  var deletError = "";
  void _showConfrimDeleteDialog(IceDTO ice) {
    setState(() {
      deleting = false;
      deletError = "";
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              title: Text("DELETE ICE"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                      "Are you sure you want to delete this ICE? \n[NOTE: this action cannot be undone]"),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      deletError,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                          child: Text("CANCEL")),
                      deleteButton(ice)
                    ],
                  ),
                )
              ]);
        });
  }

  Widget deleteButton(IceDTO ice) {
    return deleting
        ? CircularProgressIndicator()
        : RaisedButton(
            onPressed: (() async {
              setState(() {
                deleting = true;
              });
/*
          APIService().deleteIce(ice.id, _token).then((response) {
            deleting = false;

            Navigator.of(context).pop();
            iceBloc.setIce(response);
          });*/

              try {
                var ices = await APIService().deleteIce(ice.id, appState.token);
                appState.updateIce = ices;
              } catch (e) {
                print(e);
              }
            }),
            child: Text("DELETE ICE"),
            color: Colors.black,
            textColor: Colors.white);
  }
}

class AddICeDialog extends StatefulWidget {
  AddICeDialog(this.appState, {Key key, this.title}) : super(key: key);

  final String title;
  final AppStateProvider appState;

  @override
  _AddICeDialogState createState() => _AddICeDialogState();
}

class _AddICeDialogState extends State<AddICeDialog> {
  final _formKey = GlobalKey<FormState>();

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
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setState(() {
                  _saving_changes = true;
                });

                try {
                  var ices = await APIService.getInstance()
                      .saveIce(_name, _phone, widget.appState.token);

                  widget.appState.updateIce = ices;

                  Navigator.of(context).pop();
                } catch (e) {
//                  _errorMessage = json.decode(response.body)['message'];
                  _errorMessage =
                      "Error saving changes, check your internet and try again";
                  setState(() {
                    _show_error = true;
                  });
                }
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
