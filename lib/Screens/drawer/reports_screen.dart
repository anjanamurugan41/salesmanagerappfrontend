import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/ReportsListBloc.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/LinearLoader.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/dot_type.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:sales_manager_app/Screens/drawer/reportgeneratescreen.dart';
import 'package:sales_manager_app/Screens/report_task_details_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';
import 'package:sales_manager_app/widgets/task_list_item.dart';

import '../../Models/DummyModels/1.dart';
import '../task_details_screen.dart';
import 'ReportFilterScreen.dart';

class ReportsScreen extends StatefulWidget {
  int user_id;
  ReportsScreen({Key key,this.user_id}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with LoadMoreListener {
  bool isLoadingMore = false;
  ReportsListBloc _allTasksBloc;
  ScrollController _tasksController;

  String fromDateToPass, toDateToPass, statusToPass;
  int salesPersonToPass;

  @override
  void initState() {
    super.initState();
    _tasksController = ScrollController();
    _tasksController.addListener(_scrollListener);
    _allTasksBloc = ReportsListBloc(this);
    fromDateToPass = "${DateHelper.formatDateTime(DateTime.now(), 'dd-MM-yyyy')}";
    toDateToPass = "${DateHelper.formatDateTime(DateTime.now(), 'dd-MM-yyyy')}";
    _allTasksBloc.getReportsList(false, fromDateToPass, toDateToPass, null, null);
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
          _allTasksBloc.getReportsList(true, fromDateToPass, toDateToPass,
              statusToPass, salesPersonToPass);
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
      _allTasksBloc.getReportsList(
          false, fromDateToPass, toDateToPass, statusToPass, salesPersonToPass);
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
          child: Row(
            children: [
              Expanded(
                child: CommonAppBar(
                  text: "Reports",
                  buttonHandler: _backPressFunction,
                ),
                flex: 1,
              ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 20,),
                  Text("Filter your task",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),),
                 Spacer(),
                  IconButton(
                    onPressed: () {
                      showFilterScreen();
                    },
                    iconSize: 30,
                    icon: Icon(
                      Icons.tune,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.cyan,
                  onRefresh: () {
                    return _allTasksBloc.getReportsList(false, fromDateToPass,
                        toDateToPass, statusToPass, salesPersonToPass);
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
                              return _buildUserWidget(_allTasksBloc.tasksList);
                              break;
                            case Status.ERROR:
                              return SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                child: CommonApiErrorWidget(
                                    snapshot.data.message,
                                    _errorWidgetFunction),
                              );
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
        bottomSheet: InkWell(
          onTap: (){
            showReportScreen();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(buttonBgColor),
              borderRadius: BorderRadius.only(
                topRight:Radius.circular(20) ,
                topLeft:Radius.circular(20)
              ),
            ),
            height: 50,
            child: Center(child: Text("Generate Report",style: TextStyle(color: Color(colorCodeWhite),fontSize: 14,
           fontWeight: FontWeight.w500 ),)),
          ),
        ),
      ),
    );
  }

  Widget _buildUserWidget(List<Todaytask> tasksList) {
    if (tasksList != null) {
      if (tasksList.length > 0) {
        return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(10, 15, 10, 50),
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

  void showFilterScreen() async {
    Map<String, dynamic> data = await Get.to(() => ReportFilterScreen(),
        opaque: false, fullscreenDialog: true);

    if (data != null && mounted) {
      if (data.containsKey("isFilterApplied")) {
        print("*****isFilterApplied");
        if (data["isFilterApplied"]) {
          if (data.containsKey("taskStatus")) {
            statusToPass = data["taskStatus"];
          }

          if (data.containsKey("startDate")) {
            fromDateToPass = data["startDate"];
          }

          if (data.containsKey("endDate")) {
            toDateToPass = data["endDate"];
          }

          if (data.containsKey("salesPersonId")) {
            salesPersonToPass = data["salesPersonId"];
          } else if(LoginModel().userDetails.role != "admin"){
            salesPersonToPass = LoginModel().userDetails.id;
          }

          if (_allTasksBloc != null) {
            _allTasksBloc.getReportsList(false, fromDateToPass, toDateToPass,
                statusToPass, salesPersonToPass);
          }
        }
      }
    }
  }

  void showReportScreen() async {
    print(widget.user_id);
    Map<String, dynamic> data = await Get.to(() => ReportGenerateScreen(user_id:widget.user_id),
        opaque: false, fullscreenDialog: true);

    if (data != null && mounted) {
      if (data.containsKey("isFilterApplied")) {
        print("*****isFilterApplied");
        if (data["isFilterApplied"]) {
          if (data.containsKey("taskStatus")) {
            statusToPass = data["taskStatus"];
          }

          if (data.containsKey("startDate")) {
            fromDateToPass = data["startDate"];
          }

          if (data.containsKey("endDate")) {
            toDateToPass = data["endDate"];
          }

          if (data.containsKey("salesPersonId")) {
            salesPersonToPass = data["salesPersonId"];
          } else if(LoginModel().userDetails.role != "admin"){
            salesPersonToPass = LoginModel().userDetails.id;
          }

          if (_allTasksBloc != null) {
            _allTasksBloc.getReportsList(false, fromDateToPass, toDateToPass,
                statusToPass, salesPersonToPass);
          }
        }
      }
    }
  }

  void viewTaskDetail(Todaytask taskItemToPass) async {
    Map<String, dynamic> data =
        await Get.to(() => ReportTaskDetailsScreen(taskId: taskItemToPass.taskid));

    if (data != null && mounted) {
      if (data.containsKey("refreshList")) {
        if (data["refreshList"]) {
          if (_allTasksBloc != null) {
            _allTasksBloc.getReportsList(false, fromDateToPass, toDateToPass,
                statusToPass, salesPersonToPass);
          }
        }
      }
    }
  }
}

/*
Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '20',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: ' Tasks',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )
 */
