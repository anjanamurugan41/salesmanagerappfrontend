import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/HomeBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Interfaces/RefreshPageListener.dart';
import 'package:sales_manager_app/Models/HomeSummaryResponse.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:sales_manager_app/Screens/drawer/my_tasks_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/Utilities/app_helper.dart';
import 'package:sales_manager_app/widgets/app_card.dart';
import 'package:sales_manager_app/widgets/task_list_item.dart';
import '../task_details_screen.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({Key key}) : super(key: key);

  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment>
    with RefreshPageListener {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    CommonMethods().setRefreshDashboardListener(this);
    _homeBloc = new HomeBloc();
    _homeBloc.getHomeItems();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void _errorWidgetFunction() {
    if (_homeBloc != null) {
      _homeBloc.getHomeItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.green,
        onRefresh: () {
          return _homeBloc.getHomeItems();
        },
        child: StreamBuilder<ApiResponse<HomeSummaryResponse>>(
          stream: _homeBloc.homeStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return CommonApiLoader();
                  break;
                case Status.COMPLETED:
                  return _buildUserWidget(snapshot.data.data);
                  break;
                case Status.ERROR:
                  return CommonApiErrorWidget(
                      snapshot.data.message, _errorWidgetFunction);
                  ;
                  break;
              }
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildUserWidget(HomeSummaryResponse homeResponse) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 50),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your\'s Today Status",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '${homeResponse.todaysCount == 0 ? "No" : "${homeResponse.todaysCount}"}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text:
                      '${homeResponse.todaysCount == 1 ? " Task Today" : " Tasks Today"}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black45),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AppCard(
                      margin: EdgeInsets.fromLTRB(0, 8, 8, 12),
                      height: screenWidth * .35,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/images/ic_pending.png",
                                  fit: BoxFit.fill,
                                  width: 30,
                                  height: 30,
                                ),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                            Text(
                              'Pending Tasks',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${homeResponse.countsInfo.pending == 1 ? "${homeResponse.countsInfo.pending} Task" : "${homeResponse.countsInfo.pending} Tasks"}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(() => MyTasksScreen(
                            taskStatusToList: "pending",
                            pageHeading: "Pending Task"));
                      },
                    ),
                    AppCard(
                      margin: EdgeInsets.fromLTRB(0, 8, 8, 12),
                      height: screenWidth * .35,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/images/ic_reject.png",
                                  fit: BoxFit.fill,
                                  width: 30,
                                  height: 30,
                                ),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                            Text('Rejected Tasks',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600)),
                            Text(
                              '${homeResponse.countsInfo.rejected == 1 ? "${homeResponse.countsInfo.rejected} Task" : "${homeResponse.countsInfo.rejected} Tasks"}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(() => MyTasksScreen(
                            taskStatusToList: "rejected",
                            pageHeading: "Rejected Task"));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    AppCard(
                      margin: EdgeInsets.fromLTRB(8, 8, 0, 12),
                      height: screenWidth * .45,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/images/ic_complete.png",
                                  fit: BoxFit.fill,
                                  width: 30,
                                  height: 30,
                                ),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                            Text('Completed\nTasks',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600)),
                            Text(
                              '${homeResponse.countsInfo.completed == 1 ? "${homeResponse.countsInfo.completed} Task" : "${homeResponse.countsInfo.completed} Tasks"}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(() => MyTasksScreen(
                            taskStatusToList: "completed",
                            pageHeading: "Completed Task"));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildTasksSection(homeResponse)
        ],
      ),
    );
  }

  _buildTasksSection(HomeSummaryResponse homeResponse) {
    if (homeResponse.todaysTask != null) {
      if (homeResponse.todaysTask.length > 0) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Yours Today Tasks',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.black87),
                  child: Text('See All'),
                  onPressed: () {
                    Get.to(() => MyTasksScreen(pageHeading: "Today\'s Task"));
                  },
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: homeResponse.todaysTask.length,
              itemBuilder: (context, index) {
                TaskItem taskItemToPass = homeResponse.todaysTask[index];
                return TaskListItem(
                  taskItem: taskItemToPass,
                  onTap: () {
                    viewTaskDetail(taskItemToPass);
                  },
                );
              },
            ),
          ],
        );
      }
    }

    return Container();
  }

  @override
  void refreshPage() {
    if (mounted) {
      if (_homeBloc != null) {
        _homeBloc.getHomeItems();
      }
    }
  }

  void viewTaskDetail(TaskItem taskItemToPass) async {
    Map<String, dynamic> data =
        await Get.to(() => TaskDetailsScreen(taskId: taskItemToPass.taskid));

    if (data != null && mounted) {
      if (data.containsKey("refreshList")) {
        if (data["refreshList"]) {
          if (_homeBloc != null) {
            _homeBloc.getHomeItems();
          }
        }
      }
    }
  }
}
