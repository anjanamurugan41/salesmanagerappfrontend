import 'package:sales_manager_app/Models/SalesPersonModel.dart';

import 'PersonalInfo.dart';

class TaskDetailResponse {
  bool success;
  String message;
  String status;
  TaskDetails taskDetails;
  List<Report> report;

  TaskDetailResponse(
      {this.success, this.message, this.status, this.taskDetails, this.report});

  TaskDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'] ?? -1;
    taskDetails =
        json['data'] != null ? new TaskDetails.fromJson(json['data']) : null;
    if (json['Report'] != null) {
      report = [];
      json['Report'].forEach((v) {
        report.add(new Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.taskDetails != null) {
      data['taskDetails'] = this.taskDetails.toJson();
    }
    if (this.report != null) {
      data['Report'] = this.report.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskDetails {
  int id;
  String title;
  String clientname;
  String description;
  String date;
  String time;
  String address;
  int userId;
  int status;
  String createdAt;
  String updatedAt;
  int taskCreatedBy;
  PersonalInfo person;

  TaskDetails(
      {this.id,
      this.title,
      this.clientname,
      this.description,
      this.date,
      this.time,
      this.address,
      this.userId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.taskCreatedBy,
      this.person});

  TaskDetails.fromJson(Map<String, dynamic> json) {
    id = json['taskid'];
    title = json['title'];
    clientname = json['clientname'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
    userId = json['user_id'];
    status = json['status'] ?? -1;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taskCreatedBy = json['task_created'];
    person = json['person'] != null
        ? new PersonalInfo.fromJson(json['person'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskid'] = this.id;
    data['title'] = this.title;
    data['clientname'] = this.clientname;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['task_created'] = this.taskCreatedBy;
    if (this.person != null) {
      data['person'] = this.person.toJson();
    }
    return data;
  }
}

class Report {
  int id;
  String description;
  String createdAt;
  int status;

  Report({this.id, this.description, this.createdAt, this.status});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    createdAt = json['date_shedule'] ?? "";
    status = json['status'] ?? -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['date_shedule'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
