import 'package:sales_manager_app/Models/UserDetails.dart';

class ProfileResponse {
  bool _success;
  UserDetails _userDetails;
  String _message;

  ProfileResponse({bool success, UserDetails userDetails, String message}) {
    this._success = success;
    this._userDetails = userDetails;
    this._message = message;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  UserDetails get userDetails => _userDetails;

  set userDetails(UserDetails userDetails) => _userDetails = userDetails;

  String get message => _message;

  set message(String message) => _message = message;

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _userDetails = json['data'] != null
        ? new UserDetails.fromJson(json['data'])
        : null;
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    if (this._userDetails != null) {
      data['data'] = this._userDetails.toJson();
    }
    data['message'] = this._message;
    return data;
  }
}
