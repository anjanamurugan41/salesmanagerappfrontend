import 'dart:async';

import 'package:sales_manager_app/Models/SalesPersonModel.dart';

import '../Constants/CommonMethods.dart';
import '../Repositories/CommonInfoRepository.dart';
import '../ServiceManager/ApiResponse.dart';

class SalesPersonDetailBloc {
  CommonInfoRepository commonInfoRepository;
  StreamController _profileController;

  StreamSink<ApiResponse<SalesPersonModel>> get profileSink =>
      _profileController.sink;

  Stream<ApiResponse<SalesPersonModel>> get profileStream =>
      _profileController.stream;

  SalesPersonDetailBloc() {
    _profileController = StreamController<ApiResponse<SalesPersonModel>>();
    commonInfoRepository = CommonInfoRepository();
  }

  getSalesPersonInfo(int memberId) async {
    profileSink.add(ApiResponse.loading('Fetching profile'));
    try {
      SalesPersonModel profileResponse =
          await commonInfoRepository.getSalesPersonInfo(memberId);
      if (profileResponse.success) {
        profileSink.add(ApiResponse.completed(profileResponse));
      } else {
        profileSink.add(ApiResponse.error(
            profileResponse.message ?? "Something went wrong"));
      }
    } catch (error) {
      profileSink
          .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    profileSink?.close();
    _profileController?.close();
  }
}
