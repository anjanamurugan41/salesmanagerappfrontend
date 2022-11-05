import 'dart:async';

import 'package:sales_manager_app/Models/HomeSummaryResponse.dart';
import 'package:sales_manager_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class HomeBloc {
  CommonInfoRepository _homeRepository;

  StreamController _homeController;

  StreamSink<ApiResponse<HomeSummaryResponse>> get homeSink =>
      _homeController.sink;

  Stream<ApiResponse<HomeSummaryResponse>> get homeStream =>
      _homeController.stream;

  HomeBloc() {
    _homeRepository = CommonInfoRepository();
    _homeController = StreamController<ApiResponse<HomeSummaryResponse>>();
  }

  getHomeItems() async {
    homeSink.add(ApiResponse.loading('Fetching Home info'));

    try {
      HomeSummaryResponse homeResponse = await _homeRepository.getHomeItems();
      if (homeResponse.success) {
        homeSink.add(ApiResponse.completed(homeResponse));
      } else {
        homeSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      print("***");
      print(error.toString());
      print("***");
      homeSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    homeSink?.close();
    _homeController?.close();
  }
}
