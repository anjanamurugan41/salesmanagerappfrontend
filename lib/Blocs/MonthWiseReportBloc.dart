import 'dart:async';

import 'package:sales_manager_app/Models/AllTaskResponse.dart';

import 'package:sales_manager_app/Repositories/TaskRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Models/DummyModels/1.dart';
import '../ServiceManager/ApiResponse.dart';

class MonthWiseReportBloc {
  TaskRepository tasksRepository;

  StreamController _tasksController;

  StreamSink<ApiResponse<AllTaskResponse>> get employeeListSink =>
      _tasksController.sink;

  Stream<ApiResponse<AllTaskResponse>> get tasksStream =>
      _tasksController.stream;

  List<Todaytask> tasksList = [];
  List<DateTime> presentDates = [];

  MonthWiseReportBloc() {
    tasksRepository = TaskRepository();
    _tasksController = StreamController<ApiResponse<AllTaskResponse>>();
  }

  getMonthReport(int month, int year, int salesManId) async {
    employeeListSink.add(ApiResponse.loading('Fetching reports'));
    presentDates.clear();
    presentDates = [];
    try {
      AllTaskResponse tasksResponse =
          await tasksRepository.getMonthReport(month, year, salesManId);
      if (tasksResponse.success) {
        tasksList = tasksResponse.data;
        for (var task in tasksList) {
          if (task.date != null) {
            presentDates.add(DateTime.parse(task.date));
          }
        }
        employeeListSink.add(ApiResponse.completed(tasksResponse));
      } else {
        employeeListSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      employeeListSink
          .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    employeeListSink?.close();
    _tasksController?.close();
  }
}
