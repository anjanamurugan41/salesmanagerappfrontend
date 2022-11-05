import 'PersonalInfo.dart';

class SalesPersonModel {
  bool _success;
  int _statusCode;
  PersonalInfo _personalInfo;
  String _message;

  SalesPersonModel({bool success, int statusCode, PersonalInfo personalInfo, String message}) {
    this._success = success;
    this._statusCode = statusCode;
    this._personalInfo = personalInfo;
    this._message = message;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  int get statusCode => _statusCode;

  set statusCode(int statusCode) => _statusCode = statusCode;

  PersonalInfo get personalInfo => _personalInfo;

  set personalInfo(PersonalInfo personalInfo) => _personalInfo = personalInfo;

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  SalesPersonModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _personalInfo = json['data'] != null
        ? new PersonalInfo.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['statusCode'] = this._statusCode;
    if (this._personalInfo != null) {
      data['personalInfo'] = this._personalInfo.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}


