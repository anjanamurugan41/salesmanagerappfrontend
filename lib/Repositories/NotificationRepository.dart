import 'dart:convert';

import '../Models/NotificationResponse.dart';
import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

class NotificationRepository {
  ApiProvider apiProvider;

  NotificationRepository() {
    apiProvider = new ApiProvider();
  }

  Future<NotificationResponse> getNotifications(id) async {

    final response = await apiProvider
        .getInstance()
        .post(RemoteConfig.baseUrl + RemoteConfig.getNotifications, data: {"user_id":id});
    Map apiResponse = response.data;
    print("user_id->>>$apiResponse");

    return NotificationResponse.fromJson(apiResponse);
  }
}