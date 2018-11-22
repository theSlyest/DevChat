import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seclot/utils/routes_utils.dart';
import '../data_store/user_details.dart';
import '../data_store/api_service.dart';
import '../model/user.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  UserDTO _user;

  double _width;
  File _image;

  String _bankAccountNumber = '12345 - GTBANK';
  String _cardNumber = '1234';
  String _balance = '₦0.0';

  @override
  void initState() {
    setState(() {
      _user = UserDetails().getUserData();
      _balance = "₦ ${_user.walletBalance}";
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
//      theme: ThemeData(primaryColor: Colors.black, primaryColorDark: Colors.black, accentColor: Colors.black),

      child: Scaffold(
        appBar: new AppBar(
          title: Text('Wallet'),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            balanceView(),
            Padding(
              padding: EdgeInsets.all(16.0),
            ),
//            cardDetails(),
//            bankAccount(),
            Expanded(child: paymentHistory())
          ],
        ),
      ),
    );
  }

  Widget balanceView() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(height: 200.0, color: Colors.black),
        /*Center(
                      child: new Image.asset(_image),
                    ),*/

        Column(
          children: <Widget>[
            Text(
              _balance,
              style: TextStyle(fontSize: 48.0, color: Colors.white),
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 48.0,
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: RaisedButton(
                    splashColor: Colors.grey,
                    child: new Text(
                      "Fund",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
//                      Navigator.pushNamed(context, RoutUtils.subscription);
                      APIService.getInstance()
                          .fundAccount("T055280341809835", _user.token);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(16.0))),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget cardDetails() {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: MarginUtils.walletTextViewMargins,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "CARD DETAILS",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              editBankDetailsButton(),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Container(
            margin: MarginUtils.walletTextViewMargins,
            child: Row(
              children: <Widget>[
                Text(
                  _cardNumber,
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bankAccount() {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: MarginUtils.walletTextViewMargins,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "BANK DETAILS",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              editBankDetailsButton(),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Container(
            margin:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.receipt,
                  size: 24.0,
                ),
                Text(
                  _bankAccountNumber,
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget paymentHistory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: MarginUtils.walletTextViewMargins,
          child: Text(
            "UPDATE SUBSCRIPTION",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Flexible(child: _ListView()),
      ],
    );
  }

  Widget _ListView() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          dailyPlan(),
          Container(
              color: Colors.grey,
              height: 1.0,
              margin: EdgeInsets.only(top: 16.0, bottom: 16.0)),
          weekly(),
          Container(
              color: Colors.grey,
              height: 1.0,
              margin: EdgeInsets.only(top: 16.0, bottom: 16.0)),
          monthly(),
          Container(
              color: Colors.grey,
              height: 1.0,
              margin: EdgeInsets.only(top: 16.0, bottom: 16.0)),
          yearly(),
          Container(
              color: Colors.grey,
              height: 1.0,
              margin: EdgeInsets.only(top: 16.0, bottom: 16.0))
        ],
      ),
    );
  }

  Widget dailyPlan() {
    return InkWell(
        onTap: (() {
          _showDialog("daily", "5", "5 minutes");

//          UpdateSubscriptionDialog();
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Daily plan",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Text("Price: ₦5", style: TextStyle(fontSize: 16.0)),
                SizedBox(width: 16.0),
                Text("Duration: 5 minutes", style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ],
        ));
  }

  Widget weekly() {
    return InkWell(
        onTap: (() {
          _showDialog("weekly", "10", "1 week");
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Weekly plan",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Text("Price: ₦10", style: TextStyle(fontSize: 16.0)),
                SizedBox(width: 16.0),
                Text("Duration: 1 week", style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ],
        ));
  }

  Widget monthly() {
    return InkWell(
        onTap: (() {
          _showDialog("monthly", "100", "1 Month");
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Monthly plan",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Text("Price: ₦100", style: TextStyle(fontSize: 16.0)),
                SizedBox(width: 16.0),
                Text("Duration: 1 month", style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ],
        ));
  }

  Widget yearly() {
    return InkWell(
        onTap: (() {
          _showDialog("yearly", "1000", "1 year");
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Yearly plan",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Text("Price: ₦1000", style: TextStyle(fontSize: 16.0)),
                SizedBox(width: 16.0),
                Text("Duration: 1 year", style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ],
        ));
  }

  Widget editBankDetailsButton() {
    return RaisedButton(
      child: Text(
        "EDIT",
        style: TextStyle(fontSize: 16.0),
      ),
      onPressed: () {
//        _showDialog();
      },
    );
  }

//  _showDialog(String plan, String price, String duration) async {
//    await showDialog<String>(
//      context: context,
//      child: new AlertDialog(
//        contentPadding: const EdgeInsets.all(16.0),
//        content: Container(
//          height: 150.0,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                "UPDATE SUBSCRIPTION TO ${plan.toUpperCase()} PLAN?",
//                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//              ),
//
//              SizedBox(height: 20.0),
//              Text("Price: ₦$price", style: TextStyle(fontSize: 16.0)),
//              SizedBox(height: 16.0),
//              Text("Duration: $duration", style: TextStyle(fontSize: 16.0)),
////            Row(
////              children: <Widget>[
////                Expanded(
////                  child: Text("Price", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
////              child: new TextField(
////                autofocus: true,
////                decoration: new InputDecoration(
////                    labelText: 'Full Name', hintText: 'eg. John Smith'),
////              ),
////                )
////              ],
////            ),
//            ],
//          ),
//        ),
//        actions: <Widget>[
//          new FlatButton(
//              child: const Text('CANCEL'),
//              onPressed: () {
//                Navigator.pop(context);
//              }),
//          new FlatButton(
//              child: const Text('UPDATE SUBSCRIPTION'),
//              onPressed: () {
//                Navigator.pop(context);
//              })
//        ],
//      ),
//    );
//  }
  _showDialog(String plan, String price, String duration) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return UpdateSubscriptionDialog(
            plan: plan,
            price: price,
            duration: duration,
          );
        });
  }
}

class UpdateSubscriptionDialog extends StatefulWidget {
  UpdateSubscriptionDialog({Key key, this.plan, this.price, this.duration})
      : super(key: key);

  final String plan;
  final String price;
  final String duration;

  @override
  _UpdateSubscriptionDialogState createState() =>
      _UpdateSubscriptionDialogState();
}

class _UpdateSubscriptionDialogState extends State<UpdateSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();

  var _errorMessage =
      "Error updating subscription, please check your network and try again";

  var _saving_changes = false;
  var _show_error = false;
  var _show_success = false;

  _UpdateSubscriptionDialogState() {}

  Widget _showError() {
    if (_show_error) {
      return Text(
        _errorMessage,
        style: TextStyle(color: Colors.red),
      );
    } else if (_show_success) {
      return Center(
        child: Text(
          "Subscription successful",
          style: TextStyle(color: Colors.green),
        ),
      );
    } else {
      return Container();
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "UPDATE SUBSCRIPTION TO ${widget.plan.toUpperCase()} PLAN?",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text("Price: ₦${widget.price}", style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16.0),
              Text("Duration: ${widget.duration}",
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16.0),
              _showError(),
            ],
          ),
        ),
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
            _updateSubscription(),
          ],
        )
      ],
    );
  }

  Widget _updateSubscription() {
    return _saving_changes
        ? Center(child: CircularProgressIndicator())
        : FlatButton(
            onPressed: () {
              setState(() {
                _saving_changes = true;
              });

              APIService()
                  .updateSubscription(
                      widget.plan, UserDetails().getUserData().token)
                  .then((response) {
                var responseBody = json.decode(response.body);

                if (response.statusCode == 200) {
                  //all is well

                  _show_error = false;
                  setState(() {
                    _show_success = true;
                  });
                } else {
                  //some error occured
                  _errorMessage = responseBody['message'];
                  _show_error = true;
                  _show_success = false;
                  setState(() {
                    _saving_changes = false;
                    showToast(responseBody['message']);
                  });
                }

                setState(() {
                  _saving_changes = false;
                });

                print(response);
              });
            },
            child: Text(
              'SAVE CHANGES',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
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
