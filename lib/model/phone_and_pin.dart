class LoginDetails{
  var _phoneNumber;
  var _pin;
  var _remeberMe;

  LoginDetails(this._phoneNumber, this._pin, this._remeberMe);

  String getPhoneNumber(){
    return _phoneNumber;
  }

  String getPin(){
    return _pin;
  }

  bool rememberMe(){
    return _remeberMe;
  }
}