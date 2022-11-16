import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';
import 'package:sales_manager_app/widgets/app_icon.dart';

import '../add_task_screen.dart';
import '../drawer/drawer_screen.dart';
import 'TasksFragment.dart';
import 'search_screen.dart';
import 'DashboardFragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.id}) : super(key: key);
  final int id;




  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String authToken;
  int _currentTabIndex = 0;
  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(50, 100),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    AppIcon(
                        iconData: CupertinoIcons.square_grid_2x2,
                        onTap: () {
                          Get.to(() => DrawerScreen(
                            id : widget.id,
                          ),
                              transition: Transition.fadeIn);
                        }),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            '${DateHelper.formatDateTime(DateTime.now(), 'MMM dd, yyyy')}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black45),
                          ),
                        )),
                    AppIcon(
                        iconData: CupertinoIcons.search,
                        onTap: () {
                          Get.to(() => SearchScreen());
                        }),
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_rounded),
            backgroundColor: Color(buttonBgColor),
            onPressed: () {
              Get.to(() => AddTaskScreen());
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 6,
            clipBehavior: Clip.antiAlias,
            //elevation: 1,
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              //selectedItemColor: Color(buttonBgColor),
              //unselectedItemColor: Colors.black26,
              currentIndex: _currentTabIndex,
              onTap: (int index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              //todo change tab icons
              items: [
                BottomNavigationBarItem(
                    icon: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width: 25,
                          height: 25,
                          image: _currentTabIndex != 0
                              ? AssetImage('assets/images/ic_home_unselect.png')
                              : AssetImage('assets/images/ic_home_select.png'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: _currentTabIndex == 0
                                  ? Color(colorCodePageBgGradient1)
                                  : Color(colorCoderTextGrey)),
                        )
                      ],
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          width: 25,
                          height: 25,
                          image: _currentTabIndex != 1
                              ? AssetImage('assets/images/ic_task_unselect.png')
                              : AssetImage('assets/images/ic_task_select.png'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Tasks',
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: _currentTabIndex == 1
                                  ? Color(colorCodePageBgGradient1)
                                  : Color(colorCoderTextGrey)),
                        )
                      ],
                    ),
                    label: 'Tasks'),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _currentTabIndex == 0
                    ? DashboardFragment()
                    : TasksFragment(),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: StringConstants.doubleBackExit);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
