import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      return true;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.body}");
      print("${response.statusCode}");

      return false;
    }
  }

  Future<bool> resendOTP(String phoneNumber) async {
    final OTP_URL = "$_BASE_URL/user/resend-otp?phoneNumber=$phoneNumber";

    final response = await http.get(OTP_URL);
    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      return true;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.body}");
      print("${response.statusCode}");

      return false;
    }
  }

  Future<int> verifyOTP(String phoneNumber, String OTP) async {
    final LOGIN_URL =
        "$_BASE_URL/user/verify-otp?phoneNumber=$phoneNumber&otp=$OTP";
    final response = await http.get(LOGIN_URL);

    print(LOGIN_URL);

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      var jsonData = json.decode(response.body);

      LocalStorageHelper().setAuthCode(jsonData["authCode"]);

      if (jsonData["newUser"] == true) return 1;

      return 0;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.statusCode}");
      print("${response.body}");

      return -1;
    }
  }

  Future<String> performLogin(String phone, String pin, bool rememberMe) async {
    final LOGIN_URL = "$_BASE_URL/user/login";

    var body = Map<String, String>();
    body["phoneNumber"] = phone;
    body["pin"] = pin;

    var response = await http.post(LOGIN_URL, body: body).catchError(() {
      return NO_NETWORK_ERROR;
    }).timeout(const Duration(seconds: 15), onTimeout: () {
      return http.Response(json.encode({"message": "timeout"}), 3000);
    });

    if (response.statusCode == 200) {
//      print(response.body);

      var resBody = json.decode(response.body);

      var userDetails = UserDetails();
      userDetails.setUserData(resBody, true);
      userDetails.getUserData().token = resBody["token"];

//      UserData.getInstance().token = resBody["token"];

      if (rememberMe) {
        LocalStorageHelper().saveToken(resBody["token"]);
        var responseBody = json.decode(response.body);

//        print(responseBody["token"]);
        responseBody["profile"]["phoneNumber"] = phone;
//        print(responseBody);
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

      return "";
    } else {
      return "Login failed, please check your network and try again";
    }
  }

  Future<bool> newUser(Map<String, dynamic> body) async {
    final CREATE_ACCOUNT_URL = "$_BASE_URL/user/register";

    var header = Map<String, String>();
    header["Content-Type"] = "application/json";

    final response = await http.post(CREATE_ACCOUNT_URL,
        body: json.encode(body), headers: header);

    if (response.statusCode == 200) {
//      print(response.body);

      var resBody = json.decode(response.body);

      var userDetails = UserDetails();
      userDetails.setUserData(resBody, true);
      userDetails.getUserData().token = resBody["token"];

      LocalStorageHelper().saveToken(resBody["token"]);

      return true;
    } else {
      return false;
    }

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      LocalStorageHelper().saveAccountDetails(response.body);
      return true;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.body}");

      return false;
    }

//    return response;
  }

  Future<String> getUserProfile(String token) async {
    final CREATE_ACCOUNT_URL = "$_BASE_URL/user/profile";

    print(CREATE_ACCOUNT_URL);
    print(token);

    var header = Map<String, String>();
    header["Token"] = token;
    final response = await http.get(CREATE_ACCOUNT_URL, headers: header);

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

//      LocalStorageHelper().saveAccountDetails(response.body);
      return response.body;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.statusCode}");
      print("${response.body}");

      return "";
    }

//    return response;
  }

  Future<bool> updateUser(String token, UserDTO user) async {
    print("INSIDE UPDATE PROFILE");
    print("USER DETAILS ${user.toJson()}");

    final UPDATE_PROFILE_URL = "$_BASE_URL/user/profile";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    final response = await http.put(UPDATE_PROFILE_URL,
        headers: header, body: json.encode(user.toJson()));

    print("SENDING REQUEST NOW IN UPDATE PROFILE");

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      UserDetails().setUserData(json.decode(response.body), false);

//      LocalStorageHelper().saveAccountDetails(response.body);

      return true;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.statusCode}");
      print("${response.body}");

      return false;
    }

//    return response;
  }

  Future<bool> updateLocation(
      {String token, double latitude, double longitude}) async {
    print("INSIDE UPDATE LOCATION");

    final UPDATE_PROFILE_URL = "$_BASE_URL/user/profile";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    var body = Map<String, dynamic>();
    body["location"] = {'latitude': latitude, 'longitude': longitude};

    final response = await http.put(UPDATE_PROFILE_URL,
        headers: header, body: json.encode(body));

    print("SENDING LOCATION DATA NOW IN UPDATE PROFILE");

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");

      UserDetails().setUserData(json.decode(response.body), false);

//      LocalStorageHelper().saveAccountDetails(response.body);

      return true;
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.statusCode}");
      print("${response.body}");

      return false;
    }

//    return response;
  }

  Future<bool> updateImage(String token, File _image) async {
    print("Uploading image!");
    _image.length().then((size) {
      print(size);
    });
    print(token);

    final UPDATE_PROFILE_IMAGE_URL = "$_BASE_URL/user/profile/picture";

    Map<String, dynamic> headers = Map();

    headers["Content-Type"] = "application/x-www-form-urlencoded";
    headers["Token"] = token;

    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add("image", new UploadFileInfo(_image, basename(_image.path)));
    dio
        .put("/user/profile/picture",
            data: formdata,
            options: Options(
                headers: headers,
                baseUrl: _BASE_URL,
                method: 'PUT',
                responseType: ResponseType.JSON // or ResponseType.JSON
                ))
        .then((response) => print(response))
        .catchError((error) => print(error));

//    return response;
  }

  Upload(File imageFile) async {
    final UPDATE_PROFILE_IMAGE_URL = "$_BASE_URL/user/profile/picture";

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(UPDATE_PROFILE_IMAGE_URL);

    var request = new http.MultipartRequest("PUT", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  //====================================================================================================================///
  //
  //                                              WALLET
  //
  //====================================================================================================================//

  Future<String> fundAccount(String transactionReference, String token) async {
    final FUND_WALLET = "$_BASE_URL/user/fund-wallet";
    print("ENDPOING ==> $FUND_WALLET");

    print("INSIDE FUND TOKEN");
    print("TOKKEN ==> $token");
    print("TRANSACTION REF ==> $transactionReference");

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    print("HEADER ==> $header");

    var body = Map<String, String>();
    body["transactionReference"] = transactionReference;

    print("BODY ==> $body");

    final response =
        await http.post(FUND_WALLET, headers: header, body: json.encode(body));

    print("SENDING REQUEST NOW IN FUND_WALLET");

//    var encode = json.decode(response.body);

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.statusCode}");
      print("${response.body}");
    }

    return response.body;
  }

  Future<http.Response> updateSubscription(String plan, String token) async {
    final FUND_WALLET = "$_BASE_URL/user/profile/subscription";
    print("ENDPOINT ==> $FUND_WALLET");

    print("INSIDE UPDATE SUBSCRIPTION TOKEN");
    print("TOKKEN ==> $token");

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    print("HEADER ==> $header");

    var body = Map<String, String>();
    body["plan"] = plan;

    print("BODY ==> $body");

    final response =
        await http.put(FUND_WALLET, headers: header, body: json.encode(body));

    print("SENDING REQUEST NOW IN FUND_WALLET");

//    var encode = json.decode(response.body);

    if (response.statusCode == 200) {
      print("API REQUEST WAS SUCCESSFUL");
      print("${response.body}");
    } else {
      print("API REQUEST FAILED WOEFULLY");
      print("${response.statusCode}");
      print("${response.body}");
    }

    return response;
  }

  //====================================================================================================================///
  //
  //                                              ICE
  //
  //====================================================================================================================//

  Future<Map<String, dynamic>> saveIce(
      String name, String phone, String token) async {
    print("INSIDE SAVE TOKEN");

    final SAVE_IC = "$_BASE_URL/user/ice";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    var body = Map<String, String>();
    body["name"] = name;
    body["phoneNumber"] = phone;

    final response =
        await http.post(SAVE_IC, headers: header, body: json.encode(body));

    print("SENDING REQUEST NOW IN SAVE IC");

    var encode = json.decode(response.body);
    return encode;
  }

  Future<http.Response> getIce(String token) async {
    final UPDATE_ICE = "$_BASE_URL/user/ice";

    var header = Map<String, String>();
    header["Token"] = token;

    print("HEADER ==> $header");

    final response = await http.get(
      UPDATE_ICE,
      headers: header,
    );

//    var encode = json.decode(response.body);
    return response;
  }

  Future<dynamic> updateIce(IceDTO ice, String token) async {
    final UPDATE_ICE = "$_BASE_URL/user/ice/${ice.id}";

    var header = Map<String, String>();
    header["Token"] = token;
    header["Content-Type"] = "application/json";

    final response =
        await http.put(UPDATE_ICE, headers: header, body: ice.toJson());

    var encode = json.decode(response.body);
    return encode;
  }

  Future<dynamic> deleteIce(String iceId, String token) async {
    final DELETE_ICE = "$_BASE_URL/user/ice/$iceId";

    var header = Map<String, String>();
    header["Token"] = token;

    final response = await http.delete(DELETE_ICE, headers: header);

    var encode = json.decode(response.body);
    return encode;
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

    print(response);

    var encode = json.decode(response.body);
    return response;
//        if (response.statusCode == 200) {
//          print("API REQUEST WAS SUCCESSFUL");
//          print("${response.body}");
//
//          return encode['message'];
//        } else {
//          print("API REQUEST FAILED WOEFULLY");
//          print("${response.statusCode}");
//          print("${response.statusCode}");
//          print("${response.body}");
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
}
