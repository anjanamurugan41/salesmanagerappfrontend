import 'Pagination.dart';
import 'TaskItem.dart';

class AllTaskResponse {
  String message;
  int status;
  bool success;
  Pagination pagination;
  List<TaskItem> taskItemsList;

  AllTaskResponse(
      {this.message,
        this.status,
        this.success,
        this.pagination,
        this.taskItemsList});

  AllTaskResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      taskItemsList = [];
      json['data'].forEach((v) {
        taskItemsList.add(new TaskItem.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    if (this.taskItemsList != null) {
      data['data'] = this.taskItemsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


