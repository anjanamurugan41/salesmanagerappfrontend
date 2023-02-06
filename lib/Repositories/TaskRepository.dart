
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/TaskDetailResponse.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/ServiceManager/ApiProvider.dart';
import 'package:sales_manager_app/ServiceManager/RemoteConfig.dart';

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
    print("response->${response}");
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
  Future<SalesPersonToPersonModel> getSalesPersonsToPersons(

      int _pageNumber, int _perPage) async {
    var body ={};
    body["page"] = _pageNumber + 1;
    body["per_page"] = _perPage;
    final response = await apiProvider.getInstance().post(RemoteConfig.baseUrl +
        RemoteConfig.getAllSalesPersonToPersons ,data: body);
    return SalesPersonToPersonModel.fromJson(response.data);
  }

  Future<AllTaskResponse> getAllReports(int _pageNumber, int _perPage,
      String startDate, String endDate, String status, int salesPerson) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getAllReports +
        "?page=${_pageNumber + 1}" +
        "&perPage=$_perPage" +
        // "&from=${startDate ?? ""}" +
        // "&to=${endDate ?? ""}" +
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
  Future<CommonSuccessResponse> getStataus(int Id, status) async {
    var resBody = {};
    resBody["salesman_id"] = Id;
    resBody["is_active"] =status;
    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.getstatus,data: resBody);
   if(response.statusCode== 200){
     Get.back();
   }
    return CommonSuccessResponse.fromJson(response.data);
  }

  Future<CommonSuccessResponse> updateTask(String body, int taskId) async {
    final response = await apiProvider.getInstance().post(
        RemoteConfig.baseUrl + RemoteConfig.updateTask + "/$taskId",
        data: body);
    return CommonSuccessResponse.fromJson(response.data);
  }
  Future<CommonSuccessResponse> rescheduleTask(String body) async {
    final response = await apiProvider.getInstance().post(
        RemoteConfig.baseUrl + RemoteConfig.resheduleTask,
        data: body);
    print("rescheduleresponse->$response");
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


}
