import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seclot/model/notification.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/views/utils/map_utils.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AppStateProvider appState;
  List<NotificationDTO> notifications = [];
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
        ),
        body: Container(
          child: StreamBuilder<Event>(
              stream: appState.getNotifications().onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //deserialize();
//                  print(snapshot.data.snapshot.value);

                  Map<dynamic, dynamic> notifs = snapshot.data.snapshot.value;

//                  print("notifs => ${notifs.keys}");

                  notifications.clear();
                  notifs.forEach((key, value) {
                    print("key => $key");
                    print("value => $value");
                    notifications.add(NotificationDTO.fromMap(value)..id = key);
                  });

                  notifications.sort((a, b) => b.time.compareTo(a.time));

                  return notifications.isEmpty
                      ? noNotification()
                      : Material(
                          child: ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                return NotificationListItem(
                                    notifications[index]);
                              }),
                        );
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error occured, please check your network"));
                }

                return Center(child: CircularProgressIndicator());
              }),
        ));
  }

  noNotification() {
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
}

class NotificationListItem extends StatelessWidget {
  NotificationListItem(this.notification);
  final NotificationDTO notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDetails(context);
      },
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
                      color:
                          notification.seen ? Colors.transparent : Colors.black,
                      shape: BoxShape.circle),
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
                          colors: [Colors.grey[400], Colors.grey[700]]),
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
                              "${notification.subject}",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${getDate(DateTime.fromMillisecondsSinceEpoch(notification.time))}",
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
                        "${notification.message}",
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
  }

  showDetails(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${notification.subject}",
                            style: Theme.of(context).textTheme.title,
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.withOpacity(0.5),
                            margin: EdgeInsets.symmetric(vertical: 8),
                          ),
                          Text("${notification.message}")
                        ],
                      ),
                    )),
                    notification.longitude == -0.0 && notification.longitude == -0.0 ? SizedBox() : SizedBox(
                      height: 48,
                      width: double.maxFinite,
                      child: RaisedButton(
                        onPressed: () {
                          MapUtils.openMap(notification.latitude, notification.longitude);
                        },
                        color: Colors.black,
                        child: Text(
                          "VIEW LOCATION",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}

var today = DateTime.now();
var week = DateFormat("EEEE");
var hour = DateFormat("hh:mm a");
var full = DateFormat("dd-MMM-yy");
var dateFormat = DateFormat("dd-MMM-yy | hh:mm a");

String getDate(DateTime time) {
  if (time.day == today.day) {
    return hour.format(time);
  } else if (time.difference(today).inDays < 7) {
    return week.format(time);
  }

  return full.format(time);
}
