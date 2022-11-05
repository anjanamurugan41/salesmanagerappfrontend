import 'dart:async';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../Models/NotificationResponse.dart';
import '../Repositories/NotificationRepository.dart';
import '../ServiceManager/ApiResponse.dart';

class NotificationBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;

  NotificationRepository notificationRepository;

  StreamController _notificationController;

  StreamSink<ApiResponse<NotificationResponse>> get notificationSink =>
      _notificationController.sink;

  Stream<ApiResponse<NotificationResponse>> get notificationStream =>
      _notificationController.stream;

  List<NotificationItems> notificationsList = List();

  LoadMoreListener _listener;

  NotificationBloc(this._listener) {
    notificationRepository = new NotificationRepository();
    _notificationController =
        StreamController<ApiResponse<NotificationResponse>>();
  }

  getNotifications(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      notificationSink.add(ApiResponse.loading('Fetching notifications'));
    }
    try {
      NotificationResponse notificationResponse =
          await notificationRepository.getNotifications(pageNumber, perPage);
      if (notificationResponse.pagination != null) {
        if (notificationResponse.pagination.hasNextPage) {
          hasNextPage = notificationResponse.pagination.hasNextPage;
        }
        if (notificationResponse.pagination.page != null) {
          pageNumber = notificationResponse.pagination.page;
        }
      }
      if (isPagination) {
        if (notificationsList.length == 0) {
          notificationsList = notificationResponse.items;
        } else {
          notificationsList.addAll(notificationResponse.items);
        }
      } else {
        notificationsList = notificationResponse.items;
      }
      notificationSink.add(ApiResponse.completed(notificationResponse));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        notificationSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    notificationSink?.close();
    _notificationController?.close();
  }
}
