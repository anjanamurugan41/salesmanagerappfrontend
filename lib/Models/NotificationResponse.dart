class NotificationResponse {
    int status;
    bool success;
    String message;
    List<Notifications> notifications;
    int uCount;
    int tCount;
    Pagination pagination;

    NotificationResponse(
        {this.status,
            this.success,
            this.message,
            this.notifications,
            this.uCount,
            this.tCount,
            this.pagination});

    NotificationResponse.fromJson(Map<String, dynamic> json) {
        status = json['status'];
        success = json['success'];
        message = json['message'];
        if (json['notifications'] != null) {
            notifications = new List<Notifications>();
            json['notifications'].forEach((v) {
                notifications.add(new Notifications.fromJson(v));
            });
        }
        uCount = json['uCount'];
        tCount = json['tCount'];
        pagination = json['pagination'] != null
            ? new Pagination.fromJson(json['pagination'])
            : null;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        data['success'] = this.success;
        data['message'] = this.message;
        if (this.notifications != null) {
            data['notifications'] =
                this.notifications.map((v) => v.toJson()).toList();
        }
        data['uCount'] = this.uCount;
        data['tCount'] = this.tCount;
        if (this.pagination != null) {
            data['pagination'] = this.pagination.toJson();
        }
        return data;
    }
}

class Notifications {
    String id;
    Data data;
    String time;

    Notifications({this.id, this.data, this.time});

    Notifications.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        data = json['data'] != null ? new Data.fromJson(json['data']) : null;
        time = json['time'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        data['time'] = this.time;
        return data;
    }
}

class Data {
    String name;
    String type;
    int taskId;
    String task_title;

    Data({this.name, this.type, this.taskId,this.task_title});

    Data.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        type = json['type'];
        taskId = json['task_id'];
        task_title = json['task_title'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['type'] = this.type;
        data['task_id'] = this.taskId;
        data['task_title']= this.task_title;

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