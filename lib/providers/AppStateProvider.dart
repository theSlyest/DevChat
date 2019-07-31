import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/api_service.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/model/ice.dart';
import 'package:seclot/model/notification.dart';
import 'package:seclot/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class AppStateProvider extends ChangeNotifier {
  DatabaseReference dbRef;
  DatabaseReference ref;
  FirebaseDatabase database = FirebaseDatabase.instance;
  AppState appState;
  int unreadMessageCount = 0;

  UserDTO get user => appState.user;
  String get token => appState.token;
  String get password => appState.password;
  double get latitude => appState.latitude;
  double get longitude => appState.longitude;
  IceDAO get ice => appState.iceDAO;
  get unreadMessage => unreadMessageCount == null ? 0 : unreadMessageCount;

  AppStateProvider() {
    appState = AppState();
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  set latitude(double latitude) {
    appState.latitude = latitude;
  }

  set longitude(double longitude) {
    appState.longitude = longitude;
  }

  set user(UserDTO user) {
    print("updating user => ${user.toFullJson()}");
    appState.user = user;
    if (latitude == -0.0 && longitude == -0.0) {
      latitude = user.latitude;
      longitude = user.longitude;
      print("setting location");
    }else if(latitude != user.latitude && longitude != user.longitude){
      user.latitude = latitude;
      user.longitude = longitude;
      //updating location
      print("updating location");
      APIService.getInstance().updateUser(token, user);
    }
    //setup notification listener
    ref = database.reference().child(user.phone);
    saveInfo();
    watchNotification();
    notifyListeners();
  }

  set token(String token) {
    appState.token = token;
    notifyListeners();
  }

  set password(String token) {
    appState.password = token;
    notifyListeners();
  }

  set ice(IceDAO ice) {
    if ((ice.cooperateIce.isNotEmpty && appState.iceDAO.cooperateIce.isEmpty) ||
        (ice.personalIce.isNotEmpty && appState.iceDAO.personalIce.isEmpty)) {
      appState.iceDAO = ice;
      print("setting ice now... $ice");
    }

//    notifyListeners();
  }

  set updateIce(IceDAO ice) {
    appState.iceDAO = ice;
    print("setting ice now...");
    notifyListeners();
  }

  void saveDetails(UserAndToken userAndToken) {
    LocalStorageHelper helper = LocalStorageHelper();
    helper.saveUserAndToken(userAndToken);
  }

  void logout() {
    LocalStorageHelper helper = LocalStorageHelper();
    helper.clearUserAndToken();
  }

  void setLocation({double latitude, double longitude}) {
    this.latitude = latitude;
    this.longitude = longitude;

    //save lat lon
  }

  void watchNotification() {
    ref.child("notifications").onValue.listen((event) {
      print("notification added value changed");
      print("NOTIFICAITONS => ${event.snapshot.value}");
    });

    ref.child("newNotifications").onValue.listen((event) {
//      print("new notification");
//      print("NEW NOTIFICATIONS => ${event.snapshot.value}");
      unreadMessageCount = event.snapshot.value;
      notifyListeners();
    });
  }

  void sendNotification() {
    //send
    var ices = <String>[];
    ices.addAll(ice.personalIce.map((ic) => ic.phoneNumber).toList());
    ices.addAll(ice.cooperateIce.map((ic) => ic.phoneNumber).toList());

    var notif = NotificationDTO();
    notif.type = "distress";
    notif.latitude = user.latitude;
    notif.longitude = user.longitude;
    notif.message =
        "${user.firstName} ${user.lastName} is in trouble. Needs your help. Last known location lat: $latitude lon: $longitude. Hurry!!!";
    ref
        .child("sent")
        .push()
        .set({"notification": notif.toMap(), "recipients": ices});
  }

  void saveInfo() {
    print("saving info to ${appState.user.phone}");
    //saving info
//    ref.child("profile").update(user.toFullJson());
  }

  Query getNotifications() {
    return ref
        .child("notifications")
        .orderByChild('time') //order by creation time.
        .limitToFirst(100); //limited to get only 10 documents.
  }

  void saveFCMToken(String fcmToken) {
    ref.update({"fcmToken": fcmToken});
  }

  void clearUnread() {
    ref.update({"newNotifications": 0});
  }
  void messageSeen(String messageId) {
    ref.child("notifications").child(messageId).update({"seen": true});
  }

//  void cancelSubscriptions();
}

class AppState {
  double latitude = -0.0;
  double longitude = -0.0;
  UserDTO user;
  String token;
  String password;
  IceDAO iceDAO;

  AppState() {
    user = null;
    token = "";
    password = "";
    iceDAO = IceDAO()
      ..personalIce = []
      ..cooperateIce = [];
  }
}

class UserAndToken {
  String token = "";
  UserDTO user;
  String password;
}
