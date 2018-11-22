import '../model/user.dart';

class UserDetails {
  static final UserDetails _singleton = new UserDetails._internal();

  factory UserDetails() {
    return _singleton;
  }

  UserDetails._internal() {}

  static UserDTO _user = UserDTO();

  void setUserData(Map<String, dynamic> json, bool hasToke) {
    print("IN SET USER DATA => $json");

    _user = UserDTO.fromJson(json, hasToke);
    print("USER => $json");
    print("USER => ${_user.toFullJson()}");
  }

  UserDTO getUserData() {
    print(_user.token);

    return _user;
  }
}
