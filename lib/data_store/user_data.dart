class UserData{
  static UserData _singleton = null;

  static UserData getInstance(){
    if(_singleton == null){
      _singleton = UserData();
    }
    return _singleton;
  }


//  String firstName = "";
//  String lastName = "";
//  String id = "";
  String token = "";
}