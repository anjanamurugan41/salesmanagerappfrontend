class TaskItem {
  int taskid;
  int userId;
  String title;
  String date;
  String time;
  String clientname;
  String description;
  String task_created;
  int status;
  String address;

  TaskItem(
      {this.taskid,
        this.userId,
        this.title,
        this.date,
        this.time,
        this.clientname,
        this.description,
        this.status,
        this.address,this.task_created});

  TaskItem.fromJson(Map<String, dynamic> json) {
    taskid = json['taskid'];
    userId = json['user_id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    clientname = json['clientname'];
    description = json['description'];
    status = json['status'] ?? -1;
    address = json['address'];
    task_created = json['task_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskid'] = this.taskid;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['date'] = this.date;
    data['time'] = this.time;
    data['clientname'] = this.clientname;
    data['description'] = this.description;
    data['status'] = this.status;
    data['address'] = this.address;
    data['task_created'] = this.task_created;
    return data;
  }
}
