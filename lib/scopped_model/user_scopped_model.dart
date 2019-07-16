import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seclot/model/user.dart';

class UserModel extends Model {
  UserDTO _user = UserDTO();
  UserDTO get user => _user;

  void setUser(UserDTO user) {
    _user = user;
  }

  /// Wraps [ScopedModel.of] for this [Model].
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  void setUserData(Map<String, dynamic> json) {
    print("IN SET USERMODEL DATA => $json");

    _user = UserDTO.fromJson(json);
    notifyListeners();
    print("USER => $json");
    print("USER => ${_user.toFullJson()}");
  }

  void updateUserData(Map<String, dynamic> json) {
    print("IN SET USERMODEL DATA => $json");

    _user.update(json);
    notifyListeners();

    print("USER => $json");
    print("USER => ${_user.toFullJson()}");
  }

  UserDTO getUserData() {
    print(_user.token);

    return _user;
  }
}

final userModel = UserModel();
