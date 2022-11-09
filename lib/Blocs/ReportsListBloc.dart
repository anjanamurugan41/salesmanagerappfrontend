import 'dart:async';

import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:sales_manager_app/Repositories/TaskRepository.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';

class ReportsListBloc {
  bool hasNextPage = false;
  int pageNumber = -1;
  int perPage = 20;

  TaskRepository tasksRepository;

  StreamController _tasksController;

  StreamSink<ApiResponse<AllTaskResponse>> get employeeListSink =>
      _tasksController.sink;

  Stream<ApiResponse<AllTaskResponse>> get tasksStream =>
      _tasksController.stream;

  List<TaskItem> tasksList = [];

  LoadMoreListener _listener;

  ReportsListBloc(this._listener) {
    tasksRepository = TaskRepository();
    _tasksController = StreamController<ApiResponse<AllTaskResponse>>();
  }

  getReportsList(bool isPagination, String fromDate, String toDate,
      String status, int salesMan) async {
    print("list->.${tasksList}");
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = -1;
      employeeListSink.add(ApiResponse.loading('Fetching reports'));
    }
    try {
      AllTaskResponse tasksResponse = await tasksRepository.getAllReports(
          pageNumber, perPage, fromDate, toDate, status, salesMan);
      if (tasksResponse.pagination != null) {
        if (tasksResponse.pagination.hasNextPage != null) {
          hasNextPage = tasksResponse.pagination.hasNextPage;
        }
        if (tasksResponse.pagination.page != null) {
          pageNumber = tasksResponse.pagination.page;
        }
      }
      if (isPagination) {
        if (tasksList.length == 0) {
          tasksList = tasksResponse.taskItemsList;
        } else {
          tasksList.addAll(tasksResponse.taskItemsList);
        }
      } else {
        tasksList = tasksResponse.taskItemsList;
      }
      employeeListSink.add(ApiResponse.completed(tasksResponse));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      print("******");
      print(error.toString());
      print("******");
      if (isPagination) {
        _listener.refresh(false);
      } else {
        employeeListSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    employeeListSink?.close();
    _tasksController?.close();
  }
}
