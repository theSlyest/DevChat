import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seclot/data_store/local_storage_helper.dart';
import 'package:seclot/model/ice.dart';
import 'package:seclot/model/user.dart';

class AppStateProvider extends ChangeNotifier{
  AppState appState;
  
  UserDTO get user => appState.user;
  String get token => appState.token;
  List<IceDTO> get personalIces => appState.personalIces;
  List<IceDTO> get corporateIces => appState.corporateIces;

  AppStateProvider(){
    appState = AppState();
  }

  set user(UserDTO user){
    appState.user = user;
    notifyListeners();
  }

  set token(String token){
    appState.token = token;
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
}

class AppState{
  UserDTO user;
  String token;
  List<IceDTO> personalIces;
  List<IceDTO> corporateIces;

  AppState(){
    user = null;
    token = "";
    personalIces = [];
    corporateIces = [];
  }
}

class UserAndToken{
  String token = "";
  UserDTO user;
}