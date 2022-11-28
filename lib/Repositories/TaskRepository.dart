import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/TaskDetailResponse.dart';
import 'package:sales_manager_app/ServiceManager/ApiProvider.dart';
import 'package:sales_manager_app/ServiceManager/RemoteConfig.dart';
import 'package:sales_manager_app/Utilities/app_helper.dart';


class TaskRepository {
  ApiProvider apiProvider;

  TaskRepository() {
    apiProvider = new ApiProvider();
  }

  Future<AllTaskResponse> getAllTasksList(
      String status, int _pageNumber, int _perPage, int salesPerson) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getAllTasks +
        "?page=${_pageNumber + 1}" +
        "&perPage=$_perPage" +
        "${status != null ? "&status=$status" : ""}" +
        "${salesPerson != null ? "&salesman=$salesPerson" : ""}");
    return AllTaskResponse.fromJson(response.data);
  }

  Future<AllSalesPersonResponse> getSalesPersons(
      int _pageNumber, int _perPage) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getAllSalesPersons +
        "?page=${_pageNumber + 1}" +
        "&perPage=" +
        "$_perPage");
    return AllSalesPersonResponse.fromJson(response.data);
  }

  Future<AllTaskResponse> getAllReports(int _pageNumber, int _perPage,
      String startDate, String endDate, String status, int salesPerson) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getAllReports +
        "?page=${_pageNumber + 1}" +
        "&perPage=$_perPage" +
        "&from=${startDate ?? ""}" +
        "&to=${endDate ?? ""}" +
        "${status != null ? "&status=$status" : ""}" +
        "${salesPerson != null ? "&salesPerson=$salesPerson" : ""}");
    return AllTaskResponse.fromJson(response.data);
  }

  Future<TaskDetailResponse> getTaskDetail(int taskId) async {
    final response = await apiProvider
        .getInstance()
        .get(RemoteConfig.baseUrl + RemoteConfig.getTaskDetail + "/$taskId");
    return TaskDetailResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> createTask(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.createNewTask, data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> changeSalesPersonOfTask(String body) async {
    final response = await apiProvider.getInstance().post(
        RemoteConfig.baseUrl + RemoteConfig.changeSalesPerson,
        data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> removeTask(int taskId) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.deleteTask + "/$taskId");
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> updateTask(String body, int taskId) async {
    final response = await apiProvider.getInstance().post(
        RemoteConfig.baseUrl + RemoteConfig.updateTask + "/$taskId",
        data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> updateTaskStatus(String body) async {
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.updateTaskStatus, data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<AllTaskResponse> getMonthReport(
      int month, int year, int salesPerson) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getMonthWiseReport +
        "?month=$month" +
        "&year=$year" +
        "&salesman=$salesPerson");
    return AllTaskResponse.fromJson(response.data);
  }

  Future<AllTaskResponse> getTreatmentReport() async {

    Permission permissions = await Permission.manageExternalStorage;
    if (permissions.status != PermissionStatus.granted) {
      final res = await Permission.manageExternalStorage.request();
      print(res);
    }
    String dt = DateTime.now().toString().split('.').last;

    final savePath = Platform.isAndroid
        ? (await getExternalStorageDirectory())?.path
        : (await getApplicationDocumentsDirectory()).path;
    print(savePath.toString());
    String emulted0 = savePath.split('Android').first;
    print(emulted0);
    toastMessage("Download Started");
    final response = await apiProvider.getInstance().download(
        '${RemoteConfig.getTreatmentReport}',
        '${emulted0}/Download/report_${dt}.pdf',
        options: Options(responseType: ResponseType.bytes),
        deleteOnError: true);
    toastMessage("Download Completed");
    return response.data;
  }
}
