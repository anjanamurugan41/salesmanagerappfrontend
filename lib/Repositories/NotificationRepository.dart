import '../Models/NotificationResponse.dart';
import '../ServiceManager/ApiProvider.dart';
import '../ServiceManager/RemoteConfig.dart';

class NotificationRepository {
  ApiProvider apiProvider;

  NotificationRepository() {
    apiProvider = new ApiProvider();
  }

  Future<NotificationResponse> getNotifications(
      int _pageNumber, int _perPage) async {
    final response = await apiProvider.getInstance().get(RemoteConfig.baseUrl +
        RemoteConfig.getNotifications +
        "?page=" +
        "${_pageNumber + 1}" +
        "&perPage=" +
        "$_perPage");
    print("----->notification$response");
    return NotificationResponse.fromJson(response.data);
  }
}
