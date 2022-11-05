import 'dart:async';

import '../Constants/CommonMethods.dart';
import '../Models/ProfileResponse.dart';
import '../Repositories/CommonInfoRepository.dart';
import '../ServiceManager/ApiResponse.dart';
import '../Utilities/LoginModel.dart';
import '../Utilities/PreferenceUtils.dart';

class ProfileBloc {
  CommonInfoRepository commonInfoRepository;
  StreamController _profileController;

  StreamSink<ApiResponse<ProfileResponse>> get profileSink =>
      _profileController.sink;

  Stream<ApiResponse<ProfileResponse>> get profileStream =>
      _profileController.stream;

  ProfileBloc() {
    _profileController = StreamController<ApiResponse<ProfileResponse>>();
    commonInfoRepository = CommonInfoRepository();
  }

  getProfileInfo() async {
    profileSink.add(ApiResponse.loading('Fetching profile'));
    try {
      ProfileResponse profileResponse =
          await commonInfoRepository.getProfileInfo();
      if (profileResponse.success) {
        if (profileResponse.userDetails != null) {
          LoginModel().userDetails = profileResponse.userDetails;
          PreferenceUtils.setObjectToSF(
              PreferenceUtils.prefUserDetails, profileResponse.userDetails);
        }
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
