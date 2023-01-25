import 'DummyModels/1.dart';

class AllTaskResponse {
  int status;
  bool success;
  String message;
  List<Todaytask> data;
  Pagination pagination;

  AllTaskResponse(
      {this.status, this.success, this.message, this.data, this.pagination});

  AllTaskResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Todaytask>();
      json['data'].forEach((v) {
        data.add(new Todaytask.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Data {
  int taskid;
  int userId;
  String clientname;
  String title;
  String description;
  String date;
  String time;
  String address;
  int status;
  int taskCreated;
  String createdAt;
  String updatedAt;

  Data(
      {this.taskid,
        this.userId,
        this.clientname,
        this.title,
        this.description,
        this.date,
        this.time,
        this.address,
        this.status,
        this.taskCreated,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    taskid = json['taskid'];
    userId = json['user_id'];
    clientname = json['clientname'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
    status = json['status'];
    taskCreated = json['task_created'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskid'] = this.taskid;
    data['user_id'] = this.userId;
    data['clientname'] = this.clientname;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    data['status'] = this.status;
    data['task_created'] = this.taskCreated;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int page;
  int perPage;
  int totalItem;
  bool hasNextPage;
  int totalPages;

  Pagination(
      {this.page,
        this.perPage,
        this.totalItem,
        this.hasNextPage,
        this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
    totalItem = json['totalItem'];
    hasNextPage = json['hasNextPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['totalItem'] = this.totalItem;
    data['hasNextPage'] = this.hasNextPage;
    data['totalPages'] = this.totalPages;
    return data;
  }
}