import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/model/ice.dart';
import 'package:seclot/model/user.dart';

class AppStateProvider extends ChangeNotifier{
  AppState appState;
  
  UserDTO get user => appState.user;
  String get token => appState.token;
  String get password => appState.password;
  double get latitude => appState.latitude;
  double get longitude => appState.longitude;
  List<IceDTO> get personalIces => appState.personalIces;
  List<IceDTO> get corporateIces => appState.corporateIces;

  AppStateProvider(){
    appState = AppState();
  }

  set latitude(double latitude){
    appState.latitude = latitude;
  }

  set longitude(double longitude){
    appState.longitude = longitude;
  }

  set user(UserDTO user){
    appState.user = user;
    notifyListeners();
  }

  set token(String token){
    appState.token = token;
    notifyListeners();
  }
  set password(String token){
    appState.password = token;
    notifyListeners();
  }

  set personalIce(List<IceDTO> ices){
    appState.personalIces = ices;
    notifyListeners();
  }

  set corporateIce(List<IceDTO> ices){
    appState.corporateIces = ices;
    notifyListeners();
  }

  void saveDetails(UserAndToken userAndToken){
    LocalStorageHelper helper = LocalStorageHelper();
    helper.saveUserAndToken(userAndToken);
  }

  void logout(){
    LocalStorageHelper helper = LocalStorageHelper();
    helper.clearUserAndToken();
  }

  void setLocation({double latitude, double longitude}) {
    this.latitude = latitude;
    this.longitude = longitude;
    notifyListeners();
  }
}

class AppState{
  double latitude;
  double longitude;
  UserDTO user;
  String token;
  String password;
  List<IceDTO> personalIces;
  List<IceDTO> corporateIces;

  AppState(){
    user = null;
    token = "";
    password = "";
    personalIces = [];
    corporateIces = [];
  }
}

class UserAndToken{
  String token = "";
  UserDTO user;
  String password;
}