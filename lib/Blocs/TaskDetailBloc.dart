import 'dart:async';

import 'package:sales_manager_app/Models/TaskDetailResponse.dart';
import 'package:sales_manager_app/Repositories/TaskRepository.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class TaskDetailBloc {
  TaskRepository taskRepository;
  StreamController _taskDetailController;

  StreamSink<ApiResponse<TaskDetailResponse>> get taskSink =>
      _taskDetailController.sink;

  Stream<ApiResponse<TaskDetailResponse>> get taskStream =>
      _taskDetailController.stream;

  TaskDetailBloc() {
    _taskDetailController = StreamController<ApiResponse<TaskDetailResponse>>();
    taskRepository = TaskRepository();
  }

  getTaskDetail(int taskId) async {
    taskSink.add(ApiResponse.loading('Fetching profile'));
    try {
      TaskDetailResponse taskDetailResponse =
          await taskRepository.getTaskDetail(taskId);
      if (taskDetailResponse.success) {
        taskSink.add(ApiResponse.completed(taskDetailResponse));
      } else {
        taskSink.add(ApiResponse.error(
            taskDetailResponse.message ?? "Something went wrong"));
      }
    } catch (error) {
      print("****");
      print(error.toString());
      print("****");
      taskSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    taskSink?.close();
    _taskDetailController?.close();
  }
}
