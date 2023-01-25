import 'dart:convert';

import '../Models/NotificationResponse.dart';
import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

class NotificationRepository {
  ApiProvider apiProvider;

  NotificationRepository() {
    apiProvider = new ApiProvider();
  }

  Future<NotificationResponse> getNotifications(int page ,perpage) async {

    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.getNotifications, data: {"page":1,"per_page":20});

    Map apiResponse = response.data;
    print("user_id->>>$apiResponse");


    print("user_id->>>${response.data['UserName']}");

    return NotificationResponse.fromJson(response.data);
  }
}