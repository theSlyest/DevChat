import 'dart:convert';

class IceDTO {
  String id;
  String name;
  String phoneNumber;
  bool paused;
  int dateAdded;

  IceDTO({this.id, this.name, this.phoneNumber, this.paused, this.dateAdded});

  IceDTO.fromJson(Map<String, dynamic> json)
      : id = json.containsKey("id") ? json['id'] : "Not set",
        name = json.containsKey("name") ? json['name'] : "Not set",
        phoneNumber =
            json.containsKey("phoneNumber") ? json['phoneNumber'] : "Not set",
        paused = json.containsKey("paused") ? json['paused'] : "Not set",
        dateAdded = json.containsKey("dateAdded") ? json['dateAdded'] : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'paused': paused,
        'dateAdded': dateAdded,
      };
}


class IceDAO {
  var personalIce = List<IceDTO>();
  var cooperateIce = List<IceDTO>();

  IceDAO();
  static IceDAO deserializeIceFromResponse(Map<String, dynamic> resBody){
    print(resBody);

    print("Transforming ice...");
    var iceDao = IceDAO();

    List<dynamic> personalIceJsonList = resBody['userICEs'];
    List<dynamic> cooperateIceJsonList = resBody['organizationICEs'];

    for (Map<String, dynamic> ice in personalIceJsonList) {
      iceDao.personalIce.add(IceDTO.fromJson(ice));
    }

    for (Map<String, dynamic> ice in cooperateIceJsonList) {
      iceDao.cooperateIce.add(IceDTO.fromJson(ice));
    }

    return iceDao;
  }
}
