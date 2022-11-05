import 'package:dio/dio.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/LoginResponse.dart';
import 'package:sales_manager_app/Models/ProfileResponse.dart';
import 'package:sales_manager_app/Models/SalesPersonModel.dart';
import 'package:sales_manager_app/Models/forgot_pass_update_pass_response.dart';

import '../Constants/CommonMethods.dart';
import '../Repositories/CommonInfoRepository.dart';
import '../Utilities/LoginModel.dart';
import '../Utilities/PreferenceUtils.dart';

class CommonInfoBloc {
  CommonInfoRepository commonInfoRepository;

  CommonInfoBloc() {
    commonInfoRepository = CommonInfoRepository();
  }

  Future<LoginResponse> userLogin(String body) async {
    try {
      LoginResponse loginResponse =
          await commonInfoRepository.authenticateUser(body);
      return loginResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<ForgotPassUpdatePassResponse> resetPassword(String body) async {
    try {
      ForgotPassUpdatePassResponse response =
          await commonInfoRepository.resetPassword(body);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> changePassword(String body) async {
    try {
      CommonSuccessResponse response =
      await commonInfoRepository.changePassword(body);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> registerUser(String body) async {
    try {
      CommonSuccessResponse response =
          await commonInfoRepository.registerSalesManager(body);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<ProfileResponse> updateProfile(FormData formData) async {
    try {
      ProfileResponse response =
          await commonInfoRepository.updateProfile(formData);
      if (response.userDetails != null) {
        LoginModel().userDetails = response.userDetails;
        PreferenceUtils.setObjectToSF(
            PreferenceUtils.prefUserDetails, response.userDetails);
      }
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> createSalesPerson(String body) async {
    try {
      CommonSuccessResponse response =
          await commonInfoRepository.createSalesPerson(body);
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> logoutUser() async {
    try {
      CommonSuccessResponse response = await commonInfoRepository.logoutUser();
      return response;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }
}
