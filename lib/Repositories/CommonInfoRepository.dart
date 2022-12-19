import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/HomeSummaryResponse.dart';
import 'package:sales_manager_app/Models/LoginResponse.dart';
import 'package:sales_manager_app/Models/ProfileResponse.dart';
import 'package:sales_manager_app/Models/SalesPersonModel.dart';
import 'package:sales_manager_app/Models/SearchResponse.dart';
import 'package:sales_manager_app/Models/forgot_pass_update_pass_response.dart';
import 'package:sales_manager_app/Utilities/app_helper.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';

import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

var report;

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

  // Future getpdfofreport(body) async {
  //   final response = await apiProvider
  //       .getInstance()
  //       .post(RemoteConfig.baseUrl + RemoteConfig.getpdfofreport,data:body );
  //   report = response;
  //   return response;
  // }
  Future<File> getPdfOfReport(int id, DateTime fromDate,DateTime toDate) async {
    Permission permissions = await Permission.manageExternalStorage;
    if (permissions.status != PermissionStatus.granted) {
      final res = await Permission.manageExternalStorage.request();
      print(res);
    }
    String dt = DateTime.now().toString().split('.').last;
    final formData = jsonEncode({
      "salesman_id": id,
      "from_date": "${DateHelper.formatDateTime(fromDate,'yyyy-MM-dd')}",
      "to_date":"${DateHelper.formatDateTime(toDate,'yyyy-MM-dd')}"
    });
    final savePath = Platform.isAndroid
        ? (await getExternalStorageDirectory())?.path
        : (await getApplicationDocumentsDirectory()).path;
    print(savePath.toString());
    String emulted0 = savePath.split('Android').first;
    print(emulted0);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    toastMessage("Download Started");
    final response = await apiProvider.getInstance().download(
        '${RemoteConfig.baseUrl}'
            '${RemoteConfig.getpdfofreport}',
        '${emulted0}/Download/report_${dt}.pdf',
        options: Options(responseType: ResponseType.bytes, method: "post"),
        deleteOnError: true,
        data: formData);
    File pdf = File('${emulted0}/Download/report_${dt}.pdf');
    toastMessage("Download Completed");
    return pdf;
  }
}
