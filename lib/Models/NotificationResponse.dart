class NotificationResponse {
    bool success;
    int statusCode;
    String message;
    List<UserName> userName;

    NotificationResponse(
        {this.success, this.statusCode, this.message, this.userName});

    NotificationResponse.fromJson(Map<String, dynamic> json) {
        success = json['success'];
        statusCode = json['status_code'];
        message = json['message'];
        if (json['UserName'] != null) {
            userName = new List<UserName>();
            json['UserName'].forEach((v) {
                userName.add(new UserName.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['success'] = this.success;
        data['status_code'] = this.statusCode;
        data['message'] = this.message;
        if (this.userName != null) {
            data['UserName'] = this.userName.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class UserName {
    String name;
    int userId;
    String image;
    String title;
    String time;

    UserName({this.name, this.userId, this.image, this.title, this.time});

    UserName.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        userId = json['user_id'];
        image = json['image'];
        title = json['title'];
        time = json['time'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['user_id'] = this.userId;
        data['image'] = this.image;
        data['title'] = this.title;
        data['time'] = this.time;
        return data;
    }
}