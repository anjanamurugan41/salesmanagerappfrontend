class OtpResponse {
  String message;
  int status;
  bool success;
  int otp;

  OtpResponse({this.message, this.status, this.success, this.otp});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    data['otp'] = this.otp;
    return data;
  }
}
