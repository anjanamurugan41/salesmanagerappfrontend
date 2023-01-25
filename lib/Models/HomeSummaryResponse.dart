import 'DummyModels/1.dart';


class HomeSummaryResponse {
  int status;
  String message;
  bool success;
  String date;
  CountsInfo data;
  List<Todaytask> todaytask;
  int todaysCount;

  HomeSummaryResponse(
      {this.status,
        this.message,
        this.success,
        this.date,
        this.data,
        this.todaytask,
        this.todaysCount});

  HomeSummaryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'];
    date = json['date'];
    data = json['data'] != null
        ? new CountsInfo.fromJson(json['data'])
        : null;
    if (json['todaytask'] != null) {
      todaytask = [];
      json['todaytask'].forEach((v) {
        todaytask.add(new Todaytask.fromJson(v));
      });
    }
    todaysCount = json['todaysCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['success'] = this.success;
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.todaytask != null) {
      data['todaytask'] = this.todaytask.map((v) => v.toJson()).toList();
    }
    data['todaysCount'] = this.todaysCount;
    return data;
  }
}

class CountsInfo {
  int completed;
  int pending;
  int rejected;
  int rescheduled;

  CountsInfo({this.completed, this.pending, this.rejected, this.rescheduled});

  CountsInfo.fromJson(Map<String, dynamic> json) {
    completed = json['completed'] ?? 0;
    pending = json['Pending'] ?? 0;
    rejected = json['Rejected'] ?? 0;
    rescheduled = json['Rescheduled'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed'] = this.completed;
    data['Pending'] = this.pending;
    data['Rejected'] = this.rejected;
    data['Rescheduled'] = this.rescheduled;
    return data;
  }
}

