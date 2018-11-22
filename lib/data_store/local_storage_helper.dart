import 'package:seclot/model/phone_and_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  final login_details = "login_details";
  final _phone_and_pin = "phone_and_pin";
  final _phone = "phone";
  final _pin = "_pin";
  final _token = "_token";
  final _auth_code = "auth_code";
  final _autoLogin = "auto_login";
  final _account_details = "account_details";

  static final LocalStorageHelper _singleton =
      new LocalStorageHelper._internal();

  LocalStorageHelper._internal();

  factory LocalStorageHelper() {
    return _singleton;
  }

  Future<bool> getAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_autoLogin) ?? false);
  }

  Future<bool> toggleAutoLogin(bool autoLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_autoLogin, autoLogin);
  }

  Future<String> getLoginDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(login_details) ?? "");
  }

  Future<bool> saveLoginDetails(String loginDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(login_details, "$loginDetails");
  }

  Future<String> getPhoneAndPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_phone_and_pin) ?? "");
  }

  Future<bool> savePhoneAndPin(String authCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_phone_and_pin, "$authCode");
  }

  Future<bool> savePhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_phone, "$phone");
  }

  Future<String> getPhon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_phone) ?? "");
  }

  Future<bool> savePin(String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_pin, "$pin");
  }

  Future<String> getPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_pin) ?? "");
  }

  Future<String> getAuthCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return (prefs.getString(_auth_code) ?? "");
  }

  Future<bool> setAuthCode(String authCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_auth_code, "$authCode");
  }

  Future<String> getAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_account_details) ?? "");
  }

  Future<bool> saveAccountDetails(String accountDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_account_details, "$accountDetails");
  }

  //==================================================================
  Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_token, "$token");
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_token) ?? "");
  }

//      SharedPreferences prefs = await SharedPreferences.getInstance();
//
//      int counter = (prefs.getInt('counter') ?? 0) + 1;
//      print('Pressed $counter times.');
//      await prefs.setInt('counter', counter);
}
