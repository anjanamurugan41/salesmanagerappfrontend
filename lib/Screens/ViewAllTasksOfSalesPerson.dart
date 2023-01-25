import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/AllTasksBloc.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/LinearLoader.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/dot_type.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:sales_manager_app/Screens/task_details_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/widgets/task_list_item.dart';

import '../Models/DummyModels/1.dart';

class ViewAllTasksOfSalesPerson extends StatefulWidget {
  int salesPersonId;

  ViewAllTasksOfSalesPerson({Key key, this.salesPersonId}) : super(key: key);

  @override
  _ViewAllTasksOfSalesPersonState createState() =>
      _ViewAllTasksOfSalesPersonState();
}

class _ViewAllTasksOfSalesPersonState extends State<ViewAllTasksOfSalesPerson>
    with LoadMoreListener {
  String filter = "Pending";
  bool isLoadingMore = false;
  AllTasksBloc _allTasksBloc;
  ScrollController _tasksController;
  bool isToRefreshInfo = false;

  @override
  void initState() {
    super.initState();
    _tasksController = ScrollController();
    _tasksController.addListener(_scrollListener);
    _allTasksBloc = AllTasksBloc(this);
    _allTasksBloc.getAllTasksList(
        false, filter.toLowerCase(), widget.salesPersonId);
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
          _allTasksBloc.getAllTasksList(
              true, filter.toLowerCase(), widget.salesPersonId);
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
      _allTasksBloc.getAllTasksList(
          false, filter.toLowerCase(), widget.salesPersonId);
    }
  }

  void _backPressFunction() {
    print("clicked");
    Get.back(result: isToRefreshInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        _backPressFunction();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CommonAppBar(
                  text: "$filter Tasks",
                  buttonHandler: _backPressFunction,
                ),
                flex: 1,
              ),
              _buildFilterInfo(),
              SizedBox(
                width: 5,
              )
            ],
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
                    return _allTasksBloc.getAllTasksList(
                        false, filter.toLowerCase(), widget.salesPersonId);
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
        ),
      ),
    ));
  }

  Widget _buildUserWidget(List<Todaytask> tasksList, int totalItemsCount) {
    if (tasksList != null) {
      if (tasksList.length > 0) {
        return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(12, 12, 12, 50),
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
            });
      } else {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: CommonApiResultsEmptyWidget("Results Empty",
              textColorReceived: Colors.black),
        );
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.black);
    }
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

  void viewTaskDetail(Todaytask taskItemToPass) async {
    Map<String, dynamic> data =
        await Get.to(() => TaskDetailsScreen(taskId: taskItemToPass.taskid));

    if (data != null && mounted) {
      if (data.containsKey("refreshList")) {
        if (data["refreshList"]) {
          isToRefreshInfo = true;
          if (_allTasksBloc != null) {
            _allTasksBloc.getAllTasksList(
                false, filter.toLowerCase(), widget.salesPersonId);
          }
        }
      }
    }
  }

  _buildFilterInfo() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.tune),
      itemBuilder: (BuildContext context) {
        return ['Completed', 'Pending', 'Rejected'].map((value) {
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

        _allTasksBloc.getAllTasksList(false, filter.toLowerCase(), null);
      },
    );
  }
}
