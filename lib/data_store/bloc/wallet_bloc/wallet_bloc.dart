import 'dart:async';
import 'dart:convert';
import 'package:seclot/model/ice.dart';
import 'package:http/http.dart' as http;
export 'wallet_bloc_provider.dart';

class WalletBloc {
//  final iceDAO = IceDAO();
  final _userDetailsController = StreamController<http.Response>.broadcast();

  Stream<IceDAO> get walletIces =>
      _userDetailsController.stream.asBroadcastStream().transform(transformer);

  var transformer = StreamTransformer<http.Response, IceDAO>.fromHandlers(
      handleData: (data, sink) {
    if (data.statusCode != 200) {
      sink.addError(
          "Error fetching Ice, please check your network and try again");
    } else {
      Map<String, dynamic> resBody = json.decode(data.body);
      print(resBody);

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

      sink.add(iceDAO);
    }
  });

  setIce(http.Response ices) {
    _userDetailsController.add(ices);
  }

  setError(String error) {}

  void dispose() {
    _userDetailsController.close();
  }
}

final iceBloc = WalletBloc();

class IceDAO {
  var personalIce = List<IceDTO>();
  var cooperateIce = List<IceDTO>();
}
