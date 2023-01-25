import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/AllTasksBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/LinearLoader.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/dot_type.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Interfaces/RefreshPageListener.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/widgets/task_list_item.dart';

import '../../Models/DummyModels/1.dart';
import '../task_details_screen.dart';

class TasksFragment extends StatefulWidget {
  const TasksFragment({Key key}) : super(key: key);

  @override
  _TasksFragmentState createState() => _TasksFragmentState();
}

class _TasksFragmentState extends State<TasksFragment>
    with LoadMoreListener, RefreshPageListener {
  String filter = "Pending";
  bool isLoadingMore = false;
  AllTasksBloc _allTasksBloc;
  ScrollController _tasksController;

  @override
  void initState() {
    super.initState();
    CommonMethods().setRefreshDashboardListener(this);
    _tasksController = ScrollController();
    _tasksController.addListener(_scrollListener);
    _allTasksBloc = AllTasksBloc(this);
    _allTasksBloc.getAllTasksList(false, filter.toLowerCase(), null);
  }

  @override
  void dispose() {
    _tasksController.dispose();
    _allTasksBloc.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_tasksController.offset >= _tasksController.position.maxScrollExtent &&
        !_tasksController.position.outOfRange) {
      print("reach the bottom");
      if (_allTasksBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _allTasksBloc.getAllTasksList(true, filter.toLowerCase(), null);
        });
      }
    }
    if (_tasksController.offset <= _tasksController.position.minScrollExtent &&
        !_tasksController.position.outOfRange) {
      print("reach the top");
    }
  }

  void _errorWidgetFunction() {
    if (_allTasksBloc != null) {
      _allTasksBloc.getAllTasksList(false, filter.toLowerCase(), null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                return _allTasksBloc.getAllTasksList(
                    false, filter.toLowerCase(), null);
              },
              child: StreamBuilder<ApiResponse<AllTaskResponse>>(
                  stream: _allTasksBloc.tasksStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return CommonApiLoader();
                          break;
                        case Status.COMPLETED:
                          AllTaskResponse response = snapshot.data.data;
                          print("0>${response}");
                          return _buildUserWidget(_allTasksBloc.tasksList,
                              response.pagination?.totalItem);
                          break;
                        case Status.ERROR:
                          return CommonApiErrorWidget(
                              snapshot.data.message, _errorWidgetFunction);
                          break;
                      }
                    }
                    return Container(
                      child: Center(
                        child: Text(""),
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
    );
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }

  Widget _buildUserWidget(List<Todaytask> tasksList, int totalItemsCount) {
    print("tasklist->${tasksList}");
    if (tasksList != null) {
      if (tasksList.length > 0) {
        return Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildFilterInfo(totalItemsCount),
              Expanded(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 50),
                    itemCount: tasksList.length,
                    controller: _tasksController,
                    itemBuilder: (context, index) {
                      Todaytask taskItemToPass = tasksList[index];
                      return TaskListItem(
                        taskItem: taskItemToPass,
                        onTap: () {
                          viewTaskDetail(taskItemToPass);
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: [
              _buildFilterInfo(0),
              SizedBox(
                height: 80,
              ),
              CommonApiResultsEmptyWidget("Results Empty",
                  textColorReceived: Colors.black)
            ],
          ),
        );
      }
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          children: [
            _buildFilterInfo(0),
            Expanded(
              child: CommonApiErrorWidget(
                  "Something went wrong", _errorWidgetFunction,
                  textColorReceived: Colors.black),
              flex: 1,
            )
          ],
        ),
      );
    }
  }

  @override
  void refreshPage() {
    if (mounted) {
      if (_allTasksBloc != null) {
        _allTasksBloc.getAllTasksList(false, filter.toLowerCase(), null);
      }
    }
  }

  void viewTaskDetail(Todaytask taskItemToPass) async {
    Map<String, dynamic> data =
        await Get.to(() => TaskDetailsScreen(taskId: taskItemToPass.taskid));

    if (data != null && mounted) {
      if (data.containsKey("refreshList")) {
        if (data["refreshList"]) {
          if (_allTasksBloc != null) {
            _allTasksBloc.getAllTasksList(false, filter.toLowerCase(), null);
          }
        }
      }
    }
  }

  _buildFilterInfo(int totalItemsCount) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$filter Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Visibility(
                child: SizedBox(height: 4),
                visible: totalItemsCount != null && totalItemsCount > 0
                    ? true
                    : false,
              ),
              Visibility(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$totalItemsCount',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            '${totalItemsCount != null ? totalItemsCount == 1 ? " Task " : " Tasks " : ""}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                visible: totalItemsCount != null && totalItemsCount > 0
                    ? true
                    : false,
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.tune),
          itemBuilder: (BuildContext context) {
            return ['Completed', 'Pending', 'Rejected','Rescheduled'].map((value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList();
          },
          onSelected: (val) {
            log(val);
            log(filter ?? 'null');
            setState(() {
              filter = val;
            });

            _allTasksBloc.getAllTasksList(false,filter.capitalizeFirst, null);
          },
        ),
      ],
    );
  }
}
