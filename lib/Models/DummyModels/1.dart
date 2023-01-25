class Todaytask {
  int taskid;
  int userId;
  String clientname;
  String title;
  String description;
  String date;
  String time;
  String address;
  int status;
  String taskCreated;
  String createdAt;
  String updatedAt;
  String name;
  int id;

  Todaytask(
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
        this.updatedAt,
        this.name,
        this.id});

  Todaytask.fromJson(Map<String, dynamic> json) {
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
    name = json['name'];
    id = json['id'];
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
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}