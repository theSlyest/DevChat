import 'dart:async';
import 'dart:convert';
import 'package:seclot/model/ice.dart';
import 'package:http/http.dart' as http;
export 'ice_bloc_provider.dart';

class IceBloc {
//  final iceDAO = IceDAO();
  final _iceStreamController = StreamController<IceDAO>.broadcast();

  Stream<IceDAO> get userIces => _iceStreamController.stream;
//      .asBroadcastStream(); //.transform(transformer);

  var transformer = StreamTransformer<http.Response, IceDAO>.fromHandlers(
      handleData: (data, sink) {
    if (data.statusCode != 200) {
      sink.addError(
          "Error fetching Ice, please check your network and try again");
    } else {
      Map<String, dynamic> resBody = json.decode(data.body);
      print(resBody);

      print("Transforming ice...");

      final iceDAO = IceDAO();

      List<dynamic> personalIceJsonList = resBody['userICEs'];
      List<dynamic> cooperateIceJsonList = resBody['organizationICEs'];

//    print(personalIceJsonList);
//    print(cooperateIceJsonList);

      iceDAO.personalIce.clear();
      for (Map<String, dynamic> ice in personalIceJsonList) {
//      print(ice);
        iceDAO.personalIce.add(IceDTO.fromJson(ice));
      }

      iceDAO.cooperateIce.clear();
      for (Map<String, dynamic> ice in cooperateIceJsonList) {
        iceDAO.cooperateIce.add(IceDTO.fromJson(ice));
      }

//      if (iceDAO.personalIce.isEmpty && iceDAO.cooperateIce.isEmpty) {
//        sink.add(null);
//      } else {
//        sink.add(iceDAO);
//      }

      sink.add(iceDAO);
    }
  });

  setIce(http.Response data) {
    print("Setting ice...");

    if (data.statusCode != 200) {
      _iceStreamController.sink.addError(
          "Error fetching Ice, please check your network and try again");
    } else {
      Map<String, dynamic> resBody = json.decode(data.body);
      print(resBody);

      print("Transforming ice...");

      final iceDAO = IceDAO();

      List<dynamic> personalIceJsonList = resBody['userICEs'];
      List<dynamic> cooperateIceJsonList = resBody['organizationICEs'];

//    print(personalIceJsonList);
//    print(cooperateIceJsonList);

      iceDAO.personalIce.clear();
      for (Map<String, dynamic> ice in personalIceJsonList) {
//      print(ice);
        iceDAO.personalIce.add(IceDTO.fromJson(ice));
      }

      iceDAO.cooperateIce.clear();
      for (Map<String, dynamic> ice in cooperateIceJsonList) {
        iceDAO.cooperateIce.add(IceDTO.fromJson(ice));
      }

//      if (iceDAO.personalIce.isEmpty && iceDAO.cooperateIce.isEmpty) {
//        sink.add(null);
//      } else {
//        sink.add(iceDAO);
//      }

      _iceStreamController.sink.add(iceDAO);
    }
  }

  setError(String error) {}

  void dispose() {
    _iceStreamController.close();
  }
}

final iceBloc = IceBloc();
