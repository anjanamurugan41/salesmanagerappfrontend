import 'package:sales_manager_app/Models/UserDetails.dart';

import 'UserDetails.dart';

class LoginResponse {
  bool _success;
  String _message;
  String _accessToken;
  UserDetails _userInfo;

  LoginResponse(
      {bool success, String message, String accessToken, UserDetails userInfo}) {
    this._success = success;
    this._message = message;
    this._accessToken = accessToken;
    this._userInfo = userInfo;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  String get message => _message;

  set message(String message) => _message = message;

  String get accessToken => _accessToken;

  set accessToken(String accessToken) => _accessToken = accessToken;

  UserDetails get userInfo => _userInfo;

  set userInfo(UserDetails userInfo) => _userInfo = userInfo;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _accessToken = json['token'];
    _userInfo = json['data'] != null
        ? new UserDetails.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    data['token'] = this._accessToken;
    if (this._userInfo != null) {
      data['data'] = this._userInfo.toJson();
    }
    return data;
  }
}
