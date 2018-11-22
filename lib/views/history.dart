import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/color_conts.dart';
import '../data_store/api_service.dart';
import '../data_store/local_storage_helper.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _error = false;
  List<History> historyList = [];

  var _loading = true;

  @override
  void initState() {
    super.initState();

    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'HISTORY',
              textAlign: TextAlign.left,
            ),
          ),
          body: _getView()
          // _ListView(),
          ),
    );
  }

  Widget _getView() {
    if (_loading) {
      return Column(
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
      );
    } else if (_error) {
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                  "Error occured, please check your network and try again"),
            ),
          ),
          FlatButton(
            onPressed: (() {}),
//              child: Text("Cancel", style: TextStyle(),)
          )
        ],
      );
    } else {
      if (historyList.isEmpty) {
        return Container(
          child: Center(
            child: Text("No distress call history"),
          ),
        );
      } else {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: ColorUtils.light_gray,
                  padding: EdgeInsets.only(top: 24.0, bottom: 16.0, left: 24.0),
                  child: Text(
                    'History',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  )),
              _ListView()
            ],
          ),
        );
      }
    }
  }

  Widget _ListView() {
    return Expanded(
        child: ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (BuildContext content, int index) {
              History history = historyList[index];
              var date = "12:30 | Wed, 21 Nov 2018";

              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  date,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "ICE Notified:",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      "${history.iceNotified}",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Organizations Notified:",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      "${history.organizationsNotified}",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.chevron_right),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }));
  }

  void fetchHistory() {
    print("FETCHING HISTORY");
    LocalStorageHelper().getToken().then((token) {
      if (token.isEmpty) {
        //logout

        print("TOKEN NOT FOUND, SIGNING OUT NOW");
        return;
      }

      APIService().fetchCallHistory(token).then((response) {
        if (response.statusCode == 200) {
          List<dynamic> list = json.decode(response.body);

          print(list);

          if (list.isNotEmpty) {
            for (var item in list) {
//            var history = json.decode(item);
//            print(item.runtimeType);

              setState(() {
                historyList.add(History.fromJson(item));
              });
            }
          }

          setState(() {
            _loading = false;
            _error = false;
          });
        } else {
          setState(() {
            _loading = false;
            _error = true;
          });
        }
//        print(response.statusCode);
      });
    });
  }
}

class History {
  History(
      {this.iceNotified,
      this.icePhoneNumbersNotified,
      this.organizationsNotified,
      this.status,
      this.callDate});

  History.fromJson(Map<String, dynamic> json)
      : iceNotified = json.containsKey("iceNotified") ? json['iceNotified'] : 0,
        icePhoneNumbersNotified = json.containsKey("icePhoneNumbersNotified")
            ? json['icePhoneNumbersNotified']
            : [],
        organizationsNotified = json.containsKey("organizationsNotified")
            ? json['organizationsNotified']
            : 0,
        status = json.containsKey("status") ? json['status'] : "",
        callDate = json.containsKey("callDate") ? json['callDate'] : 0;

  int iceNotified;
  List<dynamic> icePhoneNumbersNotified;
  int organizationsNotified;
  String status;
  int callDate;
}
