import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/Screens/drawer/profile/CalendarPage2.dart';
import 'package:sales_manager_app/Screens/home/home_screen.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/widgets/app_icon.dart';
import 'package:sales_manager_app/screens/drawer/my_tasks_screen.dart';
import 'package:sales_manager_app/widgets/app_card.dart';

import 'calendar_screen.dart';
import 'notifications_screen.dart';
import 'profile/profile_screen.dart';
import 'reports_screen.dart';
import 'sales_person_list_screen.dart';

class DrawerScreen extends StatelessWidget {
   DrawerScreen({Key key,this.id,}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(50, 100),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcon(
                      iconData: CupertinoIcons.clear,
                      onTap: () {
                        Get.back();
                      }),
                  AppIcon(
                      iconData: CupertinoIcons.home,
                      onTap: () {
                        Get.offAll(() => HomeScreen());
                      }),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.off(() => ProfileScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.withOpacity(0.05),
                          child: ClipOval(
                            child: SizedBox.expand(
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: getImage(),
                                placeholder: (context, url) => Container(
                                  child: Center(
                                    child: RoundedLoader(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/ic_avatar.png'),
                                  ),
                                  margin: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.off(() => ProfileScreen());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${LoginModel().userDetails.name}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              LoginModel().userDetails.role == "admin"
                                  ? "Sales Manager"
                                  : "Sales Person",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      drawerItem(context, 1, "Notifications",
                          AssetImage('assets/images/ic_nav_notification.png'),),
                      drawerItem(context, 2, "Calendar",
                          AssetImage('assets/images/ic_nav_calender.png')),
                      drawerItem(context, 3, "Reports",
                          AssetImage('assets/images/ic_nav_reports.png')),
                      drawerItem(context, 4, "Today\'s Tasks",
                          AssetImage('assets/images/ic_nav_my_task.png')),
                      Visibility(
                        child: drawerItem(
                            context,
                            5,
                            "Sales Persons",
                            AssetImage(
                                'assets/images/ic_nav_sales_person.png')),
                        visible: LoginModel().userDetails.role == "admin"
                            ? true
                            : false,
                      ),
                      drawerItem(context, 6, "My Profile",
                          AssetImage('assets/images/ic_nav_profile.png')),
                      drawerItem(context, 7, "Logout",
                          AssetImage('assets/images/ic_nav_logout.png')),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(
      BuildContext context, var type, var title, var assetsImage) {

    return Container(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
      child: InkWell(
        child: Row(children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Image(
              image: assetsImage,
              height: 25.0,
              width: 25.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 10.0, 0.0),
              child: Text(title,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500)),
            ),
            flex: 1,
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.black,
          )
        ]),
        onTap: () {
          if (type == 1) {
            Get.off(() => NotificationsScreen(user_id: id,));
          } else if (type == 2) {
            //Calender
            Get.off(() => CalendarScreen());
            //Get.off(() => CalendarPage2());
          } else if (type == 3) {
            //Reports
            Get.off(() => ReportsScreen());
          } else if (type == 4) {
            // Todays tasks
            Get.off(() => MyTasksScreen(
                  pageHeading: 'My Tasks',
                ));
          } else if (type == 5) {
            // Sales person
            Get.off(() => SalesPersonListScreen(
                  isToSelectPerson: false,
                  fromPage: FromPage.DrawerPage,
                ));
          } else if (type == 6) {
            // Profile
            Get.off(() => ProfileScreen());
          } else if (type == 7) {
            // logout
            CommonWidgets().showCommonDialog(
                "Are you sure you want to Log out?",
                AssetImage('assets/images/ic_notification_message.png'),
                _alertLogoutBtnClickFunction,
                false,
                true);
          }
        },
      ),
    );
  }

  void _alertLogoutBtnClickFunction() {
    print("_alertOkBtnClickFunction clicked");
    CommonMethods().clearData();
  }

  getImage() {
    String img = "";
    if (LoginModel().userDetails != null) {
      if (LoginModel().userDetails.image != null) {
        if (LoginModel().userDetails.image != "") {
          img = LoginModel().userDetails.image;
        }
      }
    }
    return img;
  }
}
