import 'DummyModels/1.dart';

class HomeSummaryResponse {
  int status;
  String message;
  bool success;
  int todaysCount;
  Data data;
  List<Todaytask> todaytask;

  HomeSummaryResponse(
      {this.status,
        this.message,
        this.success,
        this.todaysCount,
        this.data,
        this.todaytask});

  HomeSummaryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'];
    todaysCount = json['todaysCount'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['todaytask'] != null) {
      todaytask = new List<Todaytask>();
      json['todaytask'].forEach((v) {
        todaytask.add(new Todaytask.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['success'] = this.success;
    data['todaysCount'] = this.todaysCount;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.todaytask != null) {
      data['todaytask'] = this.todaytask.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int completed;
  int pending;
  int rejected;
  int rescheduled;

  Data({this.completed, this.pending, this.rejected, this.rescheduled});

  Data.fromJson(Map<String, dynamic> json) {
    completed = json['completed'];
    pending = json['Pending'];
    rejected = json['Rejected'];
    rescheduled = json['Rescheduled'];
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

