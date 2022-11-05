class ForgotPassVerifyOtpResponse {
  String message;
  String token;
  int userId;
  bool success;

  ForgotPassVerifyOtpResponse(
      {this.message, this.token, this.userId, this.success});

  ForgotPassVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    userId = json['user_id'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['user_id'] = this.userId;
    data['success'] = this.success;
    return data;
  }
}
