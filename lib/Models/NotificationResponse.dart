class NotificationResponse {
String message;
var statusCode;
bool success;
List<UserName> userNames;

NotificationResponse({this.message, this.statusCode, this.success, this.userNames});

factory NotificationResponse.fromJson(Map<String, dynamic> json) {
return NotificationResponse(
message: json['message'],
statusCode: json['status_code'],
success: json['success'],
userNames: json['user_names'] != null ? (json['user_names'] as List).map((i) => UserName.fromJson(i)).toList() : null,
);
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['message'] = this.message;
  data['status_code'] = this.statusCode;
  data['success'] = this.success;
  if (this.userNames != null) {
    data['user_names'] = this.userNames.map((v) => v.toJson()).toList();
  }
  return data;
}
}

class UserName {
  String name;

  UserName({this.name});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}