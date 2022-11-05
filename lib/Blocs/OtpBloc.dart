import 'package:sales_manager_app/Models/forgot_pass_verify_otp_response.dart';

import '../Constants/CommonMethods.dart';
import '../Models/CommonSuccessResponse.dart';
import '../Models/OtpResponse.dart';
import '../Repositories/OtpRepository.dart';

class OtpBloc {
  OtpRepository otpRepository;

  OtpBloc() {
    otpRepository = OtpRepository();
  }

  Future<OtpResponse> sendOtp(String body) async {
    try {
      OtpResponse otpResponse = await otpRepository.getOtp(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<ForgotPassVerifyOtpResponse> verifyOtp(String body) async {
    try {
      ForgotPassVerifyOtpResponse otpResponse = await otpRepository.verifyOtp(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }
}
