import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
        ),
        body: Container(
          child: Material(
            child: ListView.builder(itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(right: 8.0, top: 8.0),
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 24,
                            ),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[400],
                                      Colors.grey[700]
                                    ]),
                                shape: BoxShape.circle),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Emmanuel Ani",
                                        style: Theme.of(context)
                                            .textTheme
                                            .title
                                            .copyWith(fontSize: 18),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "10:44 AM",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Icon(
                                      EvaIcons.arrowIosForward,
                                      size: 20,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                Text(
                                  "oga emma is in trouble and needs your help, his location Lat: 3000, Lon: 444",
                                  style: TextStyle(color: Colors.grey[600]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 16),
                          height: 0.5,
                          color: Colors.grey)
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
