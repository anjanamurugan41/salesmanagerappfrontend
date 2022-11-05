class ForgotPassUpdatePassResponse {
  List<Result> result;
  bool success;
  String message;

  ForgotPassUpdatePassResponse({this.result, this.success, this.message});

  ForgotPassUpdatePassResponse.fromJson(dynamic json) {
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    map['success'] = success;
    map['message'] = message;
    return map;
  }
}

class Result {
  int accountId;

  Result({this.accountId});

  Result.fromJson(dynamic json) {
    accountId = json['account_id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['account_id'] = accountId;
    return map;
  }
}
