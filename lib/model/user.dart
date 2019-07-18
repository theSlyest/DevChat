class UserDTO {
  String firstName;
  String lastName;
  String address;
  int seclotId;
  int registerDate;
  int walletBalance;
  String subscriptionStatus;
  String picture;
  String email;
  double latitude;
  double longitude;
  String phone;
  String referralId;
  String token;
  int accountCreationDate;
  String accountStatus;
  int nextBillDate;
  String plan;

  UserDTO()
      : firstName = "",
        lastName = "",
        address = "",
        seclotId = 0,
        registerDate = 0,
        walletBalance = 0,
        subscriptionStatus = "",
        picture = "",
        email = "",
        latitude = 0.0,
        longitude = 0.0,
        phone = "",
        referralId = "",
        accountCreationDate = 0,
        accountStatus = "",
        nextBillDate = 0,
        plan = "";

  UserDTO.fromJsonOld(Map<String, dynamic> json) {
    token = json.containsKey("token") ? json['token'] : "";
    json = json["profile"];

    firstName = json.containsKey("firstName") ? json['firstName'] : "";
    lastName = json.containsKey("lastName") ? json['lastName'] : "";
    address = json.containsKey("address") ? json['address'] : "";
    seclotId = json.containsKey("seclotId") ? json['seclotId'] : 0;
    registerDate = json.containsKey("accountCreationDate")
        ? json['accountCreationDate']
        : 0;
    walletBalance =
        json.containsKey("walletBalance") ? json['walletBalance'] : 0;
    subscriptionStatus = json.containsKey("subscriptionStatus")
        ? json['subscriptionStatus']
        : "Not set";
    picture = json.containsKey("picture") ? json['picture'] : "";
    email = json.containsKey("email") ? json['email'] : "Not set";
    latitude = json.containsKey("lastKnownLocation")
        ? json["lastKnownLocation"]['latitude']
        : 0.0;
    longitude = json.containsKey("lastKnownLocation")
        ? json["lastKnownLocation"]['longitude']
        : 0.0;
    phone = json.containsKey("phoneNumber") ? json['phoneNumber'] : "";
    referralId = json.containsKey("referralId") ? json['referralId'] : "";
    plan = json.containsKey("plan") ? json['plan'] : "";
    accountStatus =
        json.containsKey("accountStatus") ? json['accountStatus'] : "";
    accountCreationDate = json.containsKey("accountCreationDate")
        ? json['accountCreationDate']
        : 0;
    nextBillDate = json.containsKey("nextBillDate") ? json['nextBillDate'] : 0;
  }

  UserDTO.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    address = json['address'] ?? "";
    seclotId = json['seclotId'] ?? 0;
    registerDate = json['accountCreationDate'] ?? 0;
    walletBalance =
        json.containsKey("walletBalance") ? json['walletBalance'] : 0;
    subscriptionStatus = json['subscriptionStatus'] ?? "Not set";
    picture = json['picture'] ?? "";
    email = json['email'] ?? "Not set";
    latitude = json["lastKnownLocation"]['latitude'] ?? 0.0;
    longitude = json["lastKnownLocation"]['longitude'] ?? 0.0;
    phone = json['phoneNumber'] ?? "";
    referralId = json['referralId'] ?? "";
    plan = json['plan'] ?? "";
    accountStatus = json['accountStatus'] ?? "";
    accountCreationDate = json['accountCreationDate'] ?? 0;
    nextBillDate = json['nextBillDate'] ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
//        'address': address,
        'email': email,
        'location': {'latitude': latitude, 'longitude': longitude}
      };

  Map<String, dynamic> toFullJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'seclotId': seclotId,
        'registerDate': registerDate,
        'walletBalance': walletBalance,
        'subscriptionStatus': subscriptionStatus,
        'picture': picture,
        'email': email,
        'referralId': referralId,
        'lastKnownLocation': {'latitude': latitude, 'longitude': longitude},
        'accountCreationDate': accountCreationDate,
        'plan': plan,
        'accountStatus': accountStatus,
        'nextBillDate': nextBillDate
      };

  void update(Map<String, dynamic> json) {
    firstName = json.containsKey("firstName") ? json['firstName'] : "";
    lastName = json.containsKey("lastName") ? json['lastName'] : "";
    address = json.containsKey("address") ? json['address'] : "";
    seclotId = json.containsKey("seclotId") ? json['seclotId'] : 0;
    registerDate = json.containsKey("accountCreationDate")
        ? json['accountCreationDate']
        : 0;
    walletBalance =
        json.containsKey("walletBalance") ? json['walletBalance'] : 0;
    subscriptionStatus = json.containsKey("subscriptionStatus")
        ? json['subscriptionStatus']
        : "Not set";
    picture = json.containsKey("picture") ? json['picture'] : "";
    email = json.containsKey("email") ? json['email'] : "Not set";
    latitude = json.containsKey("lastKnownLocation")
        ? json["lastKnownLocation"]['latitude']
        : 0.0;
    longitude = json.containsKey("lastKnownLocation")
        ? json["lastKnownLocation"]['longitude']
        : 0.0;
    phone = json.containsKey("phoneNumber") ? json['phoneNumber'] : "";
    referralId = json.containsKey("referralId") ? json['referralId'] : "";
    plan = json.containsKey("plan") ? json['plan'] : "";
    accountStatus =
        json.containsKey("accountStatus") ? json['accountStatus'] : "";
    accountCreationDate = json.containsKey("accountCreationDate")
        ? json['accountCreationDate']
        : 0;
    nextBillDate = json.containsKey("nextBillDate") ? json['nextBillDate'] : 0;
  }
}
