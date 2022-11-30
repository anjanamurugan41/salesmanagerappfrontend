class NotificationResponse {
    bool success;
    int statusCode;
    String message;
    List<UserNames> userNames;

    NotificationResponse(
        {this.success, this.statusCode, this.message, this.userNames});

    NotificationResponse.fromJson(Map<String, dynamic> json) {
        success = json['success'];
        statusCode = json['status_code'];
        message = json['message'];
        if (json['user_names'] != null) {
            userNames = <UserNames>[];
            json['user_names'].forEach((v) {
                userNames.add(new UserNames.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['success'] = this.success;
        data['status_code'] = this.statusCode;
        data['message'] = this.message;
        if (this.userNames != null) {
            data['user_names'] = this.userNames.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class UserNames {
    String name;
    int userId;
    String image;
    String title;
    String time;

    UserNames({this.name, this.userId, this.image, this.title, this.time});

    UserNames.fromJson(Map<String, dynamic> json) {
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