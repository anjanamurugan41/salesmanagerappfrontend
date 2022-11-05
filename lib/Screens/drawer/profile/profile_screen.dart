import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/ProfileBloc.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Models/ProfileResponse.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_card.dart';

import 'update_password_screen.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = new ProfileBloc();
    profileBloc.getProfileInfo();
  }

  @override
  void dispose() {
    profileBloc.dispose();
    super.dispose();
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  void _errorWidgetFunction() {
    if (profileBloc != null) {
      profileBloc.getProfileInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "",
            buttonHandler: _backPressFunction,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return profileBloc.getProfileInfo();
            },
            child: StreamBuilder<ApiResponse<ProfileResponse>>(
              stream: profileBloc.profileStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return CommonApiLoader();
                      break;
                    case Status.COMPLETED:
                      ProfileResponse response = snapshot.data.data;
                      return _buildUserWidget(response.userDetails);
                      break;
                    case Status.ERROR:
                      return CommonApiErrorWidget(
                          snapshot.data.message, _errorWidgetFunction);
                      break;
                  }
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildUserWidget(UserDetails userDetails) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Container(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              'My Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.black87,
              radius: 60,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: '${userDetails.image}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/ic_avatar.png',
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Text(
            '${userDetails.name}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 17.0,
                color: Color(colorCodeBlack)),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Text(
            LoginModel().userDetails.role == "admin"
                ? "Sales Manager"
                : "Sales Person",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                color: Color(colorCoderTextGrey)),
          ),
          AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    CupertinoIcons.phone,
                    color: Colors.black87,
                  ),
                  title: Text(
                    '${userDetails.phone}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: Colors.black38),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.mail,
                    color: Colors.black87,
                  ),
                  title: Text(
                    '${userDetails.email}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: Colors.black38),
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          Row(
            children: [
              Expanded(
                  child: AppButton.elevated(
                text: 'Update Profile',
                onTap: () async {
                  final isProfileUpdated =
                      await Get.to(() => UpdateProfileScreen(userDetails));
                  print("*****");
                  print("$isProfileUpdated");
                  if (isProfileUpdated && profileBloc != null) {
                    profileBloc.getProfileInfo();
                  }
                },
              )),
              Expanded(
                  child: AppButton.outlined(
                text: 'Change Password',
                onTap: () {
                  Get.to(() => UpdatePasswordScreen());
                },
              )),
            ],
          ),
        ],
      ),
    );
  }
}
