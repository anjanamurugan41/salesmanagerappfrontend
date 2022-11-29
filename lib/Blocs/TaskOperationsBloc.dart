import 'dart:async';

import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Repositories/CommonInfoRepository.dart';
import 'package:sales_manager_app/Repositories/TaskRepository.dart';

class TaskOperationsBloc {
  TaskRepository otpRepository;
  CommonInfoRepository reportrepository;

  TaskOperationsBloc() {
    otpRepository = TaskRepository();
    reportrepository = CommonInfoRepository();
  }

  Future<CommonSuccessResponse> createNewTask(String body) async {
    try {
      CommonSuccessResponse otpResponse = await otpRepository.createTask(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> changeSalesPerson(String body) async {
    try {
      CommonSuccessResponse otpResponse =
          await otpRepository.changeSalesPersonOfTask(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> removeTask(int taskId) async {
    try {
      CommonSuccessResponse otpResponse =
          await otpRepository.removeTask(taskId);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> updateTask(String body, int taskId) async {
    try {
      CommonSuccessResponse otpResponse =
          await otpRepository.updateTask(body, taskId);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> rescheduleTask(
    String body,
  ) async {
    try {
      CommonSuccessResponse otpResponse =
          await otpRepository.rescheduleTask(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  Future<CommonSuccessResponse> updateTaskStatus(String body) async {
    try {
      CommonSuccessResponse otpResponse =
          await otpRepository.updateTaskStatus(body);
      return otpResponse;
    } catch (error) {
      throw CommonMethods().getNetworkError(error);
    }
  }

  // Future reportgenerate(String body,) async {
  //   try {
  //     final  otpResponse = await reportrepository.getpdfofreport(body);
  //     return otpResponse;
  //   } catch (error) {
  //     throw CommonMethods().getNetworkError(error);
  //   }
  // }
  Future reportGenerate(int id , DateTime dateFrom, DateTime dateTo) async {
    print("dowload");
    try {
      final treatmentReport = await reportrepository.getPdfOfReport(id,dateFrom,dateTo);
      return treatmentReport;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }
}
