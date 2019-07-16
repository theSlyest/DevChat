import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seclot/utils/margin_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seclot/utils/routes_utils.dart';
import '../../data_store/user_details.dart';
import '../../data_store/api_service.dart';
import '../../data_store/local_storage_helper.dart';
import '../../model/user.dart';

class FundWalletScreen extends StatefulWidget {
  @override
  _FundWalletScreenState createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _amount;
  String _cardNumber;
  String _expDateMonth;
  String _expDateYear;
  String _ccv;

  var _errorMessage =
      "Error updating subscription, please check your network and try again";

  var _saving_changes = false;
  var _show_error = false;
  var _show_success = false;

  var _amountController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  var _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000 0000 0000');
  var _expiryDateController = MaskedTextController(mask: '00/00');
  var _ccvController = MaskedTextController(mask: '000');

  get _amountInputDecoration => InputDecoration(
//        hintText: '#### #### #### #### ####',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      );
  get _emailInputDecoration => InputDecoration(
        hintText: 'you@email.com',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      );

  get _cardNumberInputDecoration => InputDecoration(
        hintText: '#### #### #### #### ####',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      );

  get _dateInputDecoration => InputDecoration(
        hintText: 'MM/YY',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      );

  get _ccvInputDecoration => InputDecoration(
        hintText: '123',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      );

  get _inputDecoration => InputDecoration(
        hintText: '1',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      );

  bool paymentReady = false;

  Future<void> initPaystack() async {
    String paystackKey = "pk_test_71cb8fa98c03c73d3ff040d7ba712af4921b3bf9";
    try {
//      await PaystackSDK.initialize(paystackKey);
      // Paystack is ready for use in receiving payments
      paymentReady = true;
    } on PlatformException {
      // well, error, deal with it
      paymentReady = true;
      //error occured
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _saving_changes = false;
    });
    initPaystack();
  }

  Widget _seperator = SizedBox(height: 20.0);
  Widget _miniSeperator = SizedBox(height: 8.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Fund Account'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
//              mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Email"),
                        _miniSeperator,
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: _emailInputDecoration,
                          validator: validateEmail,
                          onSaved: (String val) {
                            _email = val;
                          },
                        ),
                        _seperator,
                        Text("Amount"),
                        _miniSeperator,
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _amountController,
                          decoration: _amountInputDecoration,
                          onSaved: (String val) {
                            _amount =
                                val.replaceAll(",", "").replaceAll(".", "");

                            _amount = _amount.substring(0, _amount.length - 2);
                            _amount = "${int.tryParse(_amount) * 100}";
                          },
                          validator: ((value) {
                            if (value.length < 7)
                              return "You can't fund below 1000";
                          }),
                        ),
                        _seperator,
                        Text("Card Number"),
                        _miniSeperator,
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _cardNumberController,
                          decoration: _cardNumberInputDecoration,
                          validator: ((value) {
                            if (value.length < 12) return "Invalid card number";
                          }),
                          onSaved: (String val) {
                            _cardNumber = val.replaceAll(" ", "");
                          },
                        ),
                        _seperator,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Expiration Date",
                                        style: TextStyle(fontSize: 16.0)),
                                    _miniSeperator,
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: ((value) {
                                        if (value.length < 5)
                                          return "Invalid expiry date";
                                      }),
                                      controller: _expiryDateController,
                                      decoration: _dateInputDecoration,
                                      onSaved: (String val) {
                                        var split = val.split("/");
                                        _expDateMonth = split[0];
                                        _expDateYear = split[1];
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("CVC",
                                        style: TextStyle(fontSize: 16.0)),
                                    _miniSeperator,
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: ((value) {
                                        if (value.length != 3)
                                          return "Invalid ccv number";
                                      }),
                                      controller: _ccvController,
                                      decoration: _ccvInputDecoration,
                                      onSaved: (String val) {
                                        _ccv = val;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        _seperator,
                        _saveButton(context)
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid email';
    else
      return null;
  }

  _saveButton(BuildContext context) {
    return _saving_changes
        ? Container(
            child: Center(child: CircularProgressIndicator()),
          )
        : RaisedButton(
            onPressed: (() {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _makePayment();
              }
            }),
            child: Container(
                height: 52.0,
                child: Center(
                    child: Text(
                  "MAKE PAYMENT",
                  style: TextStyle(fontSize: 18.0),
                ))),
          );
  }

  _makePayment() {
    setState(() {
      _saving_changes = true;
    });

//    _expDateYear = "20$_expDateYear";

    print(_email);
    print(_cardNumber);
    print(_amount);
    print(_expDateMonth);
    print(_expDateYear);
    print(_ccv);

/*
    // pass card number, cvc, expiry month and year to the Card constructor function
    var card = PaymentCard("507850785078507812", "081", 12, 2020);

    // create a transaction with the payer's email and amount (in kobo)
    var transaction =
    PaystackTransaction("wisdom.arerosuoghene@gmail.com", 100);*/

    paymentReady = false;
    // pass card number, cvc, expiry month and year to the Card constructor function
//    var card = PaymentCard(
//        _cardNumber, _ccv, int.parse(_expDateMonth), int.parse(_expDateYear));

    // create a transaction with the payer's email and amount (in kobo)
//    var transaction = PaystackTransaction(_email, int.parse(_amount));

    // debit the card (using Javascript style promises)
//    transaction.chargeCard(card).then((transactionReference) {
//      // payment successful! You should send your transaction request to your server for validation
//      print("Transaction Ref => $transactionReference");
//
//      APIService.getInstance()
//          .fundAccount(
//              "$transactionReference", UserDetails().getUserData().token)
//          .then((response) {
//        setState(() {
//          _saving_changes = false;
//        });
//
//        if (response.statusCode == 200) {
//          showToast("Transaction successful", context);
//
//          Future.delayed(Duration(seconds: 2)).then((x) {
//            Navigator.of(context).pushNamedAndRemoveUntil(
//                RoutUtils.home, (Route<dynamic> route) => false);
//          });
//        } else {
//          showToast('Transaciton failed, please try your network and try again',
//              context);
//        }
//      });
//
//      paymentReady = true;
//    }).catchError((e) {
//      // oops, payment failed, a readable error message should be in e.message
//      print(e.message);
//
//      setState(() {
//        _saving_changes = false;
//      });
//
//      showToast("${e.message}", context);
//      paymentReady = true;
//    });
  }

  void showToast(String message, BuildContext context) {
    /* final snackBar = SnackBar(
        content: Text(message),
    action: SnackBarAction(
    label: 'Close',
    onPressed: () {
    // Some code to undo the change!
    },
    ),);*/

//    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
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
