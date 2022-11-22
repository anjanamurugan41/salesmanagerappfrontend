
import 'dart:async';

import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Models/NotificationResponse.dart';
import 'package:sales_manager_app/Repositories/NotificationRepository.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';

class NotificationBloc{
  NotificationRepository _repostiory;


  StreamController _notificationController;

  StreamSink<ApiResponse<NotificationResponse>> get notificationSink =>
      _notificationController.sink;

  Stream<ApiResponse<NotificationResponse>> get notificationStream =>
      _notificationController.stream;

  NotificationBloc() {
    _repostiory = NotificationRepository();
    _notificationController = StreamController<ApiResponse<NotificationResponse>>();
  }

  List<UserName> nameslist = [];



  getNotification() async {
    print("list->.${nameslist}");
    notificationSink.add(ApiResponse.loading('Fetching Notification'));
    try {
      NotificationResponse _notificationresponse = await _repostiory.getNotifications();
      if(_notificationresponse.success){
        if (nameslist.length == 0) {
          nameslist = _notificationresponse.userNames;
        } else {
          nameslist.addAll(_notificationresponse.userNames);
        }}
      else {
        nameslist = _notificationresponse.userNames;
      }
      notificationSink.add(ApiResponse.completed(_notificationresponse));
    } catch (error) {
      print("****");
      print(error.toString());
      print("****");
      notificationSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }
  dispose() {
    notificationSink?.close();
    _notificationController?.close();
  }
}