import 'package:sales_manager_app/Models/forgot_pass_verify_otp_response.dart';

import '../Models/CommonSuccessResponse.dart';
import '../Models/OtpResponse.dart';
import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

class OtpRepository {
  ApiProvider apiProvider;

  OtpRepository() {
    apiProvider = new ApiProvider();
  }

  Future<OtpResponse> getOtp(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.sendOtp, data: body);
    return OtpResponse.fromJson(response.data);
  }

  Future<ForgotPassVerifyOtpResponse> verifyOtp(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.verifyOtp, data: body);
    return ForgotPassVerifyOtpResponse.fromJson(response.data);
  }
}
