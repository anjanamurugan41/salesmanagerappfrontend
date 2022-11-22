import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/AllTasksBloc.dart';
import 'package:sales_manager_app/Blocs/NotificationBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/LinearLoader.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/dot_type.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/NotificationResponse.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:sales_manager_app/Screens/task_details_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/widgets/notification_list_item.dart';


class NotificationsScreen extends StatefulWidget {
  // String taskStatusToList;
  // final TaskItem taskItem;
  int user_id;

  NotificationsScreen({Key key,this.user_id}) : super(key: key);
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with LoadMoreListener {
  bool isLoadingMore = false;
  NotificationBloc _allNotificationsBloc;
  ScrollController _notificationsController;

  @override
  void initState() {
    super.initState();
    _notificationsController = ScrollController();
    _notificationsController.addListener(_scrollListener);
    _allNotificationsBloc = NotificationBloc();
    _allNotificationsBloc.getNotification();
  }

  @override
  void dispose() {
    _notificationsController.dispose();
    // _allNotificationsBloc.getNotification(user_id);
    super.dispose();
  }

  void _scrollListener() {
    if (_notificationsController.offset >= _notificationsController.position.maxScrollExtent &&
        !_notificationsController.position.outOfRange) {
      print("reach the bottom");
      if (_allNotificationsBloc.nameslist.isEmpty) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _allNotificationsBloc.getNotification();
        });
      }
    }
    if (_notificationsController.offset <= _notificationsController.position.minScrollExtent &&
        !_notificationsController.position.outOfRange) {
      print("reach the top");
    }
  }

  void _errorWidgetFunction() {
    if (_allNotificationsBloc != null) {
      _allNotificationsBloc.getNotification();
    }
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "Notifications",
            buttonHandler: _backPressFunction,
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: FractionalOffset.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.cyan,
                  onRefresh: () {
                    return _allNotificationsBloc.getNotification();
                  },
                  child: StreamBuilder<ApiResponse<NotificationResponse>>(
                      stream: _allNotificationsBloc.notificationStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return CommonApiLoader();
                              break;
                            case Status.COMPLETED:
                              NotificationResponse response = snapshot.data.data;
                              print("response->${response}");
                              return _buildUserWidget(_allNotificationsBloc.nameslist);
                              break;
                            case Status.ERROR:
                              return CommonApiErrorWidget(
                                  snapshot.data.message,
                                  _errorWidgetFunction);
                              break;
                          }
                        }
                        return Container(
                          child: Center(
                            child: Container(color: Colors.red,),
                          ),
                        );
                      }),
                ),
                flex: 1,
              ),
              Visibility(
                child: Opacity(
                  opacity: 1.0,
                  child: Container(
                    color: Colors.transparent,
                    alignment: FractionalOffset.center,
                    height: 50,
                    child: LinearLoader(
                      dotOneColor: Colors.red,
                      dotTwoColor: Colors.orange,
                      dotThreeColor: Colors.green,
                      dotType: DotType.circle,
                      dotIcon: Icon(Icons.adjust),
                      duration: Duration(seconds: 1),
                    ),
                  ),
                ),
                visible: isLoadingMore ? true : false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }

  Widget _buildUserWidget(List<UserName> namelist) {
    print("namelist->>>>>>>>${namelist[0].name}");

    if (namelist.length > 0) {
      return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(10, 15, 10, 50),
          itemCount: namelist.length,
          controller: _notificationsController,
          itemBuilder: (context, index) {
            return NotificationListItem(
              names: namelist[index].name,
              onTap: ()  {
                // viewTaskNotDetail(taskItemToPass);
              },
            );
          });
    } else {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: CommonApiResultsEmptyWidget("Results Empty",
            textColorReceived: Colors.black),
      );
    }

  }

// void viewTaskNotDetail(TaskItem taskItemToPass) async{
//   Map<String, dynamic> data = await Get.to(() =>
//       TaskDetailsScreen(taskId: taskItemToPass.taskid));
//   if (data != null && mounted) {
//     if (data.containsKey("refreshList")) {
//       if (data["refreshList"]) {
//         if (_allNotificationsBloc != null) {
//           _allNotificationsBloc.getNotification(widget.user_id);
//         }
//       }
//     }
//   }
// }
}