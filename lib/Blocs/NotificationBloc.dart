// import 'dart:async';
//
// import '../Constants/CommonMethods.dart';
// import '../Interfaces/LoadMoreListener.dart';
// import '../Models/NotificationResponse.dart';
// import '../Repositories/NotificationRepository.dart';
// import '../ServiceManager/ApiResponse.dart';
//
// class NotificationBloc {
//   bool hasNextPage = false;
//   int pageNumber = 0;
//   int perPage = 20;
//
//   NotificationRepository notificationRepository;
//
//   StreamController _notificationController;
//
//   StreamSink<ApiResponse<NotificationResponse>> get notificationSink =>
//       _notificationController.sink;
//
//   Stream<ApiResponse<NotificationResponse>> get notificationStream =>
//       _notificationController.stream;
//
//   List<NotificationItems> notificationsList = List();
//
//   LoadMoreListener _listener;
//
//   NotificationBloc(this._listener) {
//     notificationRepository = new NotificationRepository();
//     _notificationController =
//         StreamController<ApiResponse<NotificationResponse>>();
//   }
//
//   getNotifications(bool isPagination) async {
//     if (isPagination) {
//       _listener.refresh(true);
//     } else {
//       pageNumber = 0;
//       notificationSink.add(ApiResponse.loading('Fetching notifications'));
//     }
//     try {
//       NotificationResponse notificationResponse =
//           await notificationRepository.getNotifications(pageNumber, perPage);
//       if (notificationResponse.pagination != null) {
//         if (notificationResponse.pagination.hasNextPage) {
//           hasNextPage = notificationResponse.pagination.hasNextPage;
//         }
//         if (notificationResponse.pagination.page != null) {
//           pageNumber = notificationResponse.pagination.page;
//         }
//       }
//       if (isPagination) {
//         if (notificationsList.length == 0) {
//           notificationsList = notificationResponse.items;
//         } else {
//           notificationsList.addAll(notificationResponse.items);
//         }
//       } else {
//         notificationsList = notificationResponse.items;
//       }
//       notificationSink.add(ApiResponse.completed(notificationResponse));
//       if (isPagination) {
//         _listener.refresh(false);
//       }
//     } catch (error) {
//       if (isPagination) {
//         _listener.refresh(false);
//       } else {
//         notificationSink
//             .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
//       }
//     }
//   }
//
//   dispose() {
//     notificationSink?.close();
//     _notificationController?.close();
//   }
// }

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

  getNotification(int id) async {

    notificationSink.add(ApiResponse.loading('Fetching Notification'));
    try {
      NotificationResponse _notificationresponse = await _repostiory.getNotifications(id);
      print("_notificationresponse->.${_notificationresponse.userName}");

      if(_notificationresponse.success){
      if (nameslist.length == 0) {
        nameslist = _notificationresponse.userName;
        print("list->.${nameslist}");
      } else {
        nameslist.addAll(_notificationresponse.userName);
      }}
     else {
    nameslist = _notificationresponse.userName;
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
