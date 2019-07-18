import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/views/auth/login_screen.dart';
import 'package:seclot/views/auth/otp.dart';
import '../data_store/local_storage_helper.dart';
import 'package:seclot/model/ice.dart';
import 'package:seclot/model/user.dart';

import '../data_store/user_details.dart';

class APIService {
  static var NO_NETWORK_ERROR = -1;
  static var USER_NOT_FOUND_ERROR = -2;
  static var INCORRECT_PIN = -3;
  static var SUCCESS = 0;

  final _BASE_URL = "http://test.natterbase.com:4444";

  static final APIService _singleton = new APIService._internal();

  APIService._internal();

  factory APIService.getInstance() {
    return _singleton;
  }

  factory APIService() {
    return _singleton;
  }

  Future<bool> requestOTP(String phoneNumber) async {
    final OTP_URL = "$_BASE_URL/user/otp?phoneNumber=$phoneNumber";

    final response = await http.get(OTP_URL);
    if (response.statusCode == 200) {
      // print("API REQUEST WAS SUCCESSFUL");
      // print("${response.body}");

      return true;
    } else {
      // print("API REQUEST FAILED WOEFULLY");
      // print("${response.body}");
      // print("${response.statusCode}");

      return false;
    }
  }

  Future<bool> resendOTP(String phoneNumber) async {
    final OTP_URL = "$_BASE_URL/user/resend-otp?phoneNumber=$phoneNumber";

    final response = await http.get(OTP_URL);
    if (response.statusCode == 200) {
      // print("API REQUEST WAS SUCCESSFUL");
      // print("${response.body}");

      return true;
    } else {
      // print("API REQUEST FAILED WOEFULLY");
      // print("${response.body}");
      // print("${response.statusCode}");

      return false;
    }
  }

  Future<OTPResponse> verifyOTP(String phoneNumber, String OTP) async {
    final URL = "$_BASE_URL/user/verify-otp?phoneNumber=$phoneNumber&otp=$OTP";
    final response = await http.get(URL);

    // print(LOGIN_URL);

    print(response.body);
    print(response.statusCode);

    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      LocalStorageHelper().setAuthCode(jsonData["authCode"]);

      OTPResponse res = OTPResponse();
      res.newUser = response.body.contains("newUser");
      res.authCode = jsonData["authCode"];

      return res;
    } else {
      var message =
          "Error verifying otp, please check your internet and try again";
      if (jsonData["message"] != null && jsonData["message"].isNotEmpty) {
        message = jsonData["message"];
      }
      throw Exception(message);
    }
  }

  Future<bool> setPin({String authCode, String pin}) async {
    final URL = "$_BASE_URL/user/set-pin";

    var header = Map<String, String>();
    header["Content-Type"] = "application/json";

    var body =  json.encode({
      "authCode": authCode,
      "pin": pin,
    });

    final response = await http.put(URL,
        headers: header,
        body: body);

    print(body);
    print(response);

    if (response.statusCode == 200) {
//      return true;

      print(response.body);
      print(response.statusCode);

      return true;

    } else {
      print(response.body);
      print(response.statusCode);

      throw Exception("Error, please check your network and try again");
    }
  }

  /*Future<http.Response> performLogin(
      String phone, String pin, bool rememberMe) async {
    final LOGIN_URL = "$_BASE_URL/user/login";

    var body = Map<String, String>();
    body["phoneNumber"] = phone;
    body["pin"] = pin;

    var response = await http.post(LOGIN_URL, body: body).catchError(() {
      return NO_NETWORK_ERROR;
    }).timeout(const Duration(seconds: 15), onTimeout: () {
      return http.Response(json.encode({"message": "timeout"}), 3000);
    });

    if (rememberMe) {
      LocalStorageHelper().savePin(pin);
    }

    LocalStorageHelper().savePhone(phone);

    var resBody = json.decode(response.body);
    var responseBody = json.decode(response.body);
    responseBody["profile"]["phoneNumber"] = phone;

    var userDetails = UserDetails();
    userDetails.setUserData(resBody);
    userDetails.getUserData().token = resBody["token"];

    LocalStorageHelper().saveToken(resBody["token"]);
    LocalStorageHelper().saveLoginDetails(json.encode(responseBody));
    LocalStorageHelper().savePhoneAndPin(json.encode(body));

    return response;
  }*/

  Future<UserAndToken> performLogin(
      String phone, String pin, bool rememberMe) async {
    final URL = "$_BASE_URL/user/login";

    print("performing login");

    var body = Map<String, String>();
    body["phoneNumber"] = phone;
    body["pin"] = pin;

    var response = await http.post(URL, body: body);

    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      var token = resBody["token"];
      UserDTO user = UserDTO.fromJson(resBody["profile"]);
//      print(resBody);

      var userDetails = UserDetails();
      userDetails.setUserData(resBody);
      userDetails.getUserData().token = token;

//      UserData.getInstance().token = resBody["token"];

      if (rememberMe) {
        LocalStorageHelper().saveToken(resBody["token"]);
        var responseBody = json.decode(response.body);

//        // print(responseBody["token"]);
        responseBody["profile"]["phoneNumber"] = phone;
//        // print(responseBody);
        LocalStorageHelper().savePhone(phone);
        LocalStorageHelper().savePin(pin);
        LocalStorageHelper().saveLoginDetails(json.encode(responseBody));
        LocalStorageHelper().savePhoneAndPin(json.encode(body));
      } else {
        LocalStorageHelper().savePhone("");
        LocalStorageHelper().savePin("");
        LocalStorageHelper().saveLoginDetails("");
        LocalStorageHelper().savePhoneAndPin("");
      }

      UserAndToken loginInfo = UserAndToken();
      loginInfo.user = user;
      loginInfo.token = token;

      return loginInfo; //resBody["token"];
    } else {
      print(response.body);
      print(response.statusCode);

      String message = resBody['message'];
      if( message == null || message.isEmpty){
        message = "Login failed, please check your network and try again";
      }

      throw Exception(message);
    }
  }

  Future<UserAndToken> newUser(Map<String, dynamic> body) async {
    final CREATE_ACCOUNT_URL = "$_BASE_URL/user/register";

    var header = Map<String, String>();
    header["Content-Type"] = "application/json";

    final response = await http.post(CREATE_ACCOUNT_URL,
        body: json.encode(body), headers: header);

    var resBody = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
//      // print(response.body);

      // print("API REQUEST WAS SUCCESSFUL");

      var userDetails = UserDetails();
      userDetails.setUserData(resBody);
      userDetails.getUserData().token = resBody["token"];

      LocalStorageHelper().saveToken(resBody["token"]);


      UserAndToken loginInfo = UserAndToken();
      loginInfo.user = UserDTO.fromJson(resBody["profile"]);
      loginInfo.token = resBody["token"];


      return loginInfo;

    } else {
      // print("API REQUEST FAILED WOEFULLY");
      // print("${response.body}");

      String message = resBody["message"];
      if(message == null || message.isEmpty){
        message = "Error creating account, please check your network and try again";
      }

      throw Exception(message);
    }

//    return response;
  }

  Future<http.Response> getUserProfile(String token) async {
    final CREATE_ACCOUNT_URL = "$_BASE_URL/user/profile";

    // print(CREATE_ACCOUNT_URL);
    // print(token);

    var header = Map<String, String>();
    header["Token"] = token;
    final response = await http.get(CREATE_ACCOUNT_URL, headers: header);

    if (response.statusCode == 200) {
      // print("API REQUEST WAS SUCCESSFUL");
//      // print("${response.body}");

//      LocalStorageHelper().saveAccountDetails(response.body);

//      // print(response.body);
      UserDetails().updateUserData(json.decode(response.body));
    } else {
      // print("API REQUEST FAILED WOEFULLY");
      // print("${response.statusCode}");
      // print("${response.body}");
    }

    return response;

//    return response;
  }

  Future<UserDTO> updateUser(String token, UserDTO user) async {
    // print("INSIDE UPDATE PROFILE");
    // print("USER DETAILS ${user.toJson()}");

    final UPDATE_PROFILE_URL = "$_BASE_URL/user/profile";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    final response = await http.put(UPDATE_PROFILE_URL,
        headers: header, body: json.encode(user.toJson()));

    print("${response.body}");
    if (response.statusCode == 200) {

      UserDetails().updateUserData(json.decode(response.body));

      var user = UserDTO.fromJson(json.decode(response.body));

      return user;
    } else {
      var decode = json.decode(response.body);

      var message = "Error! please check your network and try again";
      if(decode != null && decode["message"] != null && decode['message'].isNotEmpty){
        message = decode["message"];
      }

      throw Exception(message);
    }

//    return response;
  }

  Future<void> updateProfileImage(
    String token,
    File image,
    Function(bool, String) onComplete,
  ) async {
    final UPDATE_PROFILE_URL = "$_BASE_URL/user/profile/picture";

    final request = http.MultipartRequest("PUT", Uri.parse(UPDATE_PROFILE_URL));

    var header = Map<String, String>();
    header["Token"] = token;
//    header["Content-Type"] = "application/x-www-form-urlencoded";

    http.MultipartFile.fromPath('image', image.path,
            contentType: MediaType('image', 'png'))
        .then((file) async {
      request.files.add(file);
      request.headers.addAll(header);
      final response = await http.Response.fromStream(
        await request.send(),
      );

      if (response.statusCode == 200) {
        // print("API REQUEST WAS SUCCESSFUL");
        // print("${response.body}");

        UserDetails().updateUserData(json.decode(response.body));

//      LocalStorageHelper().saveAccountDetails(response.body);

        onComplete(true, response.body);
      } else {
        /* // print("API REQUEST FAILED WOEFULLY");
        // print("${response.statusCode}");
        // print("${response.body}");*/

        onComplete(false, response.body);
      }
    }).catchError((error) {
      onComplete(false, "");
    });

//    return response;
  }

  Future<bool> updateLocation(
      {String token, double latitude, double longitude}) async {
//    // print("INSIDE UPDATE LOCATION");

    final UPDATE_PROFILE_URL = "$_BASE_URL/user/profile";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    var body = Map<String, dynamic>();
    body["location"] = {'latitude': latitude, 'longitude': longitude};

    final response = await http.put(UPDATE_PROFILE_URL,
        headers: header, body: json.encode(body));

//    // print("SENDING LOCATION DATA NOW IN UPDATE PROFILE");

    if (response.statusCode == 200) {
//      // print("API REQUEST WAS SUCCESSFUL");
//      // print("${response.body}");

      UserDetails().updateUserData(json.decode(response.body));

//      LocalStorageHelper().saveAccountDetails(response.body);

      return true;
    } else {
//      // print("API REQUEST FAILED WOEFULLY");
//      // print("${response.statusCode}");
//      // print("${response.body}");

      return false;
    }

//    return response;
  }

  //====================================================================================================================///
  //
  //                                              WALLET
  //
  //====================================================================================================================//

  Future<http.Response> fundAccount(
      String transactionReference, String token) async {
    final FUND_WALLET = "$_BASE_URL/user/fund-wallet";
//    // print("ENDPOING ==> $FUND_WALLET");

//    // print("INSIDE FUND TOKEN");
//    // print("TOKKEN ==> $token");
//    // print("TRANSACTION REF ==> $transactionReference");

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

//    // print("HEADER ==> $header");

    var body = Map<String, String>();
    body["transactionReference"] = transactionReference;

//    // print("BODY ==> $body");

    final response =
        await http.post(FUND_WALLET, headers: header, body: json.encode(body));

//    // print("SENDING REQUEST NOW IN FUND_WALLET");

//    var encode = json.decode(response.body);

    if (response.statusCode == 200) {
//      // print("API REQUEST WAS SUCCESSFUL");
//      // print("${response.body}");

//      getUserProfile(token);
    } else {
//      // print("API REQUEST FAILED WOEFULLY");
//      // print("${response.statusCode}");
//      // print("${response.body}");
    }

    return response;
  }

  Future<http.Response> updateSubscription(String plan, String token) async {
    final FUND_WALLET = "$_BASE_URL/user/profile/subscription";
//    // print("ENDPOINT ==> $FUND_WALLET");

//    // print("INSIDE UPDATE SUBSCRIPTION TOKEN");
//    // print("TOKKEN ==> $token");

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

//    // print("HEADER ==> $header");

    var body = Map<String, String>();
    body["plan"] = plan;

//    // print("BODY ==> $body");

    final response =
        await http.put(FUND_WALLET, headers: header, body: json.encode(body));

//    // print("SENDING REQUEST NOW IN FUND_WALLET");

//    var encode = json.decode(response.body);

    if (response.statusCode == 200) {
//      // print("API REQUEST WAS SUCCESSFUL");
//      // print("${response.body}");
    } else {
//      // print("API REQUEST FAILED WOEFULLY");
//      // print("${response.statusCode}");
//      // print("${response.body}");
    }

    return response;
  }

  //====================================================================================================================///
  //
  //                                              ICE
  //
  //====================================================================================================================//

  Future<http.Response> saveIce(String name, String phone, String token) async {
    // print("INSIDE SAVE TOKEN");

    final SAVE_IC = "$_BASE_URL/user/ice";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    var body = Map<String, String>();
    body["name"] = name;
    body["phoneNumber"] = phone;

    final response =
        await http.post(SAVE_IC, headers: header, body: json.encode(body));

    // print("SENDING REQUEST NOW IN SAVE IC");

//    var encode = json.decode(response.body);
    return response;
  }

  Future<http.Response> getIce(String token) async {
    final UPDATE_ICE = "$_BASE_URL/user/ice";

    var header = Map<String, String>();
    header["Token"] = token;

    // print("HEADER ==> $header");

    print("Getting ice...");
    final response = await http.get(
      UPDATE_ICE,
      headers: header,
    );

//    var encode = json.decode(response.body);
    return response;
  }

  Future<http.Response> updateIce(
      {String iceId, bool pause, String token}) async {
    // print("UPDATING ICE");

    final UPDATE_ICE = "$_BASE_URL/user/ice/$iceId";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    var body = Map<String, dynamic>();
    body['pause'] = pause;

    final response =
        await http.put(UPDATE_ICE, headers: header, body: json.encode(body));

    return response;
  }

  Future<dynamic> deleteIce(String iceId, String token) async {
    final DELETE_ICE = "$_BASE_URL/user/ice/$iceId";

    var header = Map<String, String>();
    header["Token"] = token;

    final response = await http.delete(DELETE_ICE, headers: header);

//    var encode = json.decode(response.body);
    return response;
  }

  //====================================================================================================================///
  //
  //                                              DISTRESS CALL
  //
  //====================================================================================================================//

  Future<http.Response> sendDistressCall(String token) async {
    final SEND_DISTRESS_CALL = "$_BASE_URL/user/distress-call";

    var header = Map<String, String>();
    header["Token"] = token;

    final response = await http.post(SEND_DISTRESS_CALL, headers: header);

    // print(response);

    var encode = json.decode(response.body);
    print(encode);
    return response;
//        if (response.statusCode == 200) {
//          // print("API REQUEST WAS SUCCESSFUL");
//          // print("${response.body}");
//
//          return encode['message'];
//        } else {
//          // print("API REQUEST FAILED WOEFULLY");
//          // print("${response.statusCode}");
//          // print("${response.statusCode}");
//          // print("${response.body}");
//
//          return encode['message'];
//        }
  }

  Future<http.Response> fetchCallHistory(String token) async {
    final FETCH_DISTRESS_CALL = "$_BASE_URL/user/distress-call";

    var header = Map<String, String>();
    header["Token"] = token;

    final response = await http.get(FETCH_DISTRESS_CALL, headers: header);

    return response;

    var encode = json.decode(response.body);
    return encode;
  }

//=================NOTIFICATION

  Future<http.Response> registerNotificationID(
      String token, String notificationId) async {
    final REGISTER_NOTIFICATION_ID = "$_BASE_URL/user/notification-id";

    var header = Map<String, String>();
    header["Content-Type"] = "application/json";
    header["Token"] = token;

    var body = {'notificationId': notificationId};
    print(body);

    var encode1 = json.encode(body);
    print(encode1);

    final response = await http.put(REGISTER_NOTIFICATION_ID,
        headers: header, body: encode1);

    return response;

    var encode = json.decode(response.body);
    return encode;
  }
}
