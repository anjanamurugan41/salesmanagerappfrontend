import 'package:dio/dio.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/HomeSummaryResponse.dart';
import 'package:sales_manager_app/Models/LoginResponse.dart';
import 'package:sales_manager_app/Models/ProfileResponse.dart';
import 'package:sales_manager_app/Models/SalesPersonModel.dart';
import 'package:sales_manager_app/Models/SearchResponse.dart';
import 'package:sales_manager_app/Models/forgot_pass_update_pass_response.dart';

import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

class CommonInfoRepository {
  ApiProvider apiProvider;

  CommonInfoRepository() {
    apiProvider = new ApiProvider();
  }

  Future<LoginResponse> authenticateUser(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.loginUser, data: body);
    return LoginResponse.fromJson(response.data);
  }

  Future<ForgotPassUpdatePassResponse> resetPassword(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.resetPassword, data: body);
    return ForgotPassUpdatePassResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> changePassword(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.changePassword, data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> registerSalesManager(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.registerUser, data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<ProfileResponse> getProfileInfo() async {
    final response = await apiProvider
        .getInstance()
        .get(RemoteConfig.baseUrl + RemoteConfig.getProfile);
    return ProfileResponse.fromJson(response.data);
  }

  Future<ProfileResponse> updateProfile(FormData formData) async {
    final response = await apiProvider.getMultipartInstance().post(
        RemoteConfig.baseUrl + RemoteConfig.updateProfile,
        data: formData);
    return ProfileResponse.fromJson(response.data);
  }

  Future<HomeSummaryResponse> getHomeItems() async {
    final response = await apiProvider
        .getInstance()
        .get(RemoteConfig.baseUrl + RemoteConfig.getHomeInfo);

    return HomeSummaryResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> createSalesPerson(String body) async {
    final response = await apiProvider.getInstance().post(
        RemoteConfig.baseUrl + RemoteConfig.createSalesPerson,
        data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<SearchResponse> getSearchResults(String keyword) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getAutoCompleteSearch +
        "?name=" +
        "$keyword");
    return SearchResponse.fromJson(response.data);
  }

  Future<SalesPersonModel> getSalesPersonInfo(int memberId) async {
    final response = await apiProvider.getInstance().get(
        RemoteConfig.baseUrl + RemoteConfig.getSalesPersonInfo + "/$memberId");
    return SalesPersonModel.fromJson(response.data);
  }

  Future<CommonSuccessResponse> logoutUser() async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.logout);
    return CommonSuccessResponse.fromJson(response.data);
  }
}
