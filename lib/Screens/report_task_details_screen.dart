import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/TaskDetailBloc.dart';
import 'package:sales_manager_app/Blocs/TaskOperationsBloc.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/TaskDetailResponse.dart';
import 'package:sales_manager_app/Screens/UpdateTaskScreen.dart';
import 'package:sales_manager_app/Screens/drawer/sales_person_details_screen.dart';
import 'package:sales_manager_app/Screens/update_task_status_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/widgets/app_card.dart';

import 'drawer/sales_person_list_screen.dart';

class ReportTaskDetailsScreen extends StatefulWidget {
  int taskId;

  ReportTaskDetailsScreen({Key key, this.taskId}) : super(key: key);

  @override
  _ReportTaskDetailsScreenState createState() => _ReportTaskDetailsScreenState();
}

class _ReportTaskDetailsScreenState extends State<ReportTaskDetailsScreen> {
  TaskDetailBloc _taskDetailBloc;
  TaskOperationsBloc _taskOperationsBloc;
  bool isChangesMade = false;

  @override
  void initState() {
    super.initState();
    _taskDetailBloc = TaskDetailBloc();
    _taskDetailBloc.getTaskDetail(widget.taskId);
    _taskOperationsBloc = TaskOperationsBloc();
  }

  @override
  void dispose() {
    _taskDetailBloc.dispose();
    super.dispose();
  }

  void _backPressFunction() {
    print("clicked");
    if (isChangesMade) {
      Map<String, dynamic> data = HashMap();
      data['refreshList'] = true;
      Get.back(result: data);
    } else {
      Get.back();
    }
  }

  void _errorWidgetFunction() {
    if (_taskDetailBloc != null) {
      _taskDetailBloc.getTaskDetail(widget.taskId);
    }
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
            body: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  onRefresh: () {
                    return _taskDetailBloc.getTaskDetail(widget.taskId);
                  },
                  child: StreamBuilder<ApiResponse<TaskDetailResponse>>(
                    stream: _taskDetailBloc.taskStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAppBar(),
                                Expanded(
                                  child: CommonApiLoader(),
                                  flex: 1,
                                )
                              ],
                            );
                            break;
                          case Status.COMPLETED:
                            return _buildUserWidget(snapshot.data.data);
                            break;
                          case Status.ERROR:
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAppBar(),
                                Expanded(
                                  child: CommonApiErrorWidget(
                                      snapshot.data.message,
                                      _errorWidgetFunction),
                                  flex: 1,
                                )
                              ],
                            );
                            break;
                        }
                      }

                      return Container();
                    },
                  ),
                ))),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 60.0, // here the desired height
      child: CommonAppBar(
        text: "",
        buttonHandler: _backPressFunction,
      ),
    );
  }

  _buildUserWidget(TaskDetailResponse taskDetailResponse) {
    if (taskDetailResponse != null && taskDetailResponse.taskDetails != null) {
      return CustomScrollView(slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.fromLTRB(0.0, 0, 0, 70),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSuccessAppBar(taskDetailResponse.taskDetails),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                    child: Text(
                      'Title',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 8),
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      '${taskDetailResponse.taskDetails.title}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: AppCard(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client Name',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${taskDetailResponse.taskDetails.clientname}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Date & Time',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.calendar,
                                        color: Colors.black45,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${taskDetailResponse.taskDetails.date}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(width: 18),
                                      Icon(
                                        CupertinoIcons.time,
                                        color: Colors.black45,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${taskDetailResponse.taskDetails.time}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${taskDetailResponse.taskDetails.address}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${taskDetailResponse.taskDetails.description}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Visibility(
                              child: Text(
                                'Assigned to',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black45,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500),
                              ),
                              visible: LoginModel().userDetails.role == "admin"
                                  ? true
                                  : false,
                            ),
                            _buildSalesPersonInfo(
                                taskDetailResponse?.taskDetails),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  _buildReports(taskDetailResponse),
                ],
              ),
            ]),
          ),
        )
      ]);
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),
          Expanded(
            child: Center(
              child: Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  "${taskDetailResponse.message ?? "Something went wrong"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            flex: 1,
          )
        ],
      );
    }
  }

  _buildSuccessAppBar(TaskDetails taskDetails) {
    return Container(
      color: Colors.transparent,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommonAppBar(
              text: "",
              buttonHandler: _backPressFunction,
            ),
            flex: 1,
          ),
          Visibility(
            child: Container(
              alignment: FractionalOffset.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    getIcon(taskDetails),
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    getStatus(taskDetails),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            visible: true,
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  _buildOptions(TaskDetailResponse taskDetailResponse) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          if (taskDetailResponse.taskDetails.status == 0 ||
              !checkIsOwner(taskDetailResponse)) {
            Fluttertoast.showToast(
                msg: "You are not permitted to perform this action");
          } else {
            editTask(taskDetailResponse.taskDetails);
          }
        } else if (value == 2) {
          if (taskDetailResponse.taskDetails.status == 0 ||
              LoginModel().userDetails.role != "admin") {
            Fluttertoast.showToast(
                msg: "You are not permitted to perform this action");
          } else {
            changeSalesPerson();
          }
        } else if (value == 3) {
          if (taskDetailResponse.taskDetails.status == 0) {
            Fluttertoast.showToast(
                msg: "You are not permitted to perform this action");
          } else {
            changeTaskStatus(taskDetailResponse.taskDetails);
          }
        } else if (value == 4) {
          if (LoginModel().userDetails.role != "admin") {
            Fluttertoast.showToast(
                msg: "You are not permitted to perform this action");
          } else {
            CommonWidgets().showCommonDialog(
                "Are you sure you, you want to delete this task?",
                AssetImage('assets/images/ic_notification_message.png'),
                deleteTask,
                false,
                true);
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Edit Task",
              style: TextStyle(
                  color: taskDetailResponse.taskDetails.status == 0 ||
                      !checkIsOwner(taskDetailResponse)
                      ? Colors.black26
                      : Color(colorCodeBlack),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Re-assign",
              style: TextStyle(
                  color: taskDetailResponse.taskDetails.status == 0 ||
                      LoginModel().userDetails.role != "admin"
                      ? Colors.black26
                      : Color(colorCodeBlack),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("Change Status",
              style: TextStyle(
                  color: taskDetailResponse.taskDetails.status == 0
                      ? Colors.black26
                      : Color(colorCodeBlack),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        PopupMenuItem(
          value: 4,
          child: Text("Delete Task",
              style: TextStyle(
                  color: LoginModel().userDetails.role != "admin"
                      ? Colors.black26
                      : Color(colorCodeBlack),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void changeSalesPerson() async {
    Map<String, dynamic> data = await Get.to(() => SalesPersonListScreen(
      isToSelectPerson: true,
      fromPage: FromPage.TaskDetailPage,
    ));

    if (data != null && mounted) {
      if (data.containsKey("selectedPersonInfo")) {
        SalesPersonInfo selectedPerson = data["selectedPersonInfo"];
        changeSalesPersonOfTask(selectedPerson);
      }
    }
  }

  void changeSalesPersonOfTask(SalesPersonInfo selectedPerson) {
    var resBody = {};
    resBody["task"] = widget.taskId;
    resBody["salesman"] = selectedPerson.id;

    CommonWidgets().showNetworkProcessingDialog();
    _taskOperationsBloc.changeSalesPerson(json.encode(resBody)).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        isChangesMade = true;
        if (_taskDetailBloc != null) {
          _taskDetailBloc.getTaskDetail(widget.taskId);
        }
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err.toString());
    });
  }

  deleteTask() {
    Get.back();
    CommonWidgets().showNetworkProcessingDialog();
    _taskOperationsBloc.removeTask(widget.taskId).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        Map<String, dynamic> data = Map();
        data['refreshList'] = true;
        Get.back(result: data);
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err.toString());
    });
  }

  void editTask(TaskDetails taskInfo) async {
    Map<String, dynamic> data = await Get.to(() => UpdateTaskScreen(
      taskDetails: taskInfo,
    ));

    if (data != null && mounted) {
      if (data.containsKey("taskUpdated")) {
        if (data["taskUpdated"]) {
          isChangesMade = true;
          if (_taskDetailBloc != null) {
            _taskDetailBloc.getTaskDetail(widget.taskId);
          }
        }
      }
    }
  }

  void changeTaskStatus(TaskDetails taskInfo) async {
    Map<String, dynamic> data = await Get.to(() => UpdateTaskStatusScreen(
      taskId: widget.taskId,
      salesManId: taskInfo.person.id,
    ));

    if (data != null && mounted) {
      if (data.containsKey("taskStatusUpdated")) {
        if (data["taskStatusUpdated"]) {
          isChangesMade = true;
          if (_taskDetailBloc != null) {
            _taskDetailBloc.getTaskDetail(widget.taskId);
          }
        }
      }
    }
  }

  _buildReports(TaskDetailResponse taskDetailResponse) {
    if (taskDetailResponse.report != null) {
      if (taskDetailResponse.report.length > 0) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                itemCount: taskDetailResponse.report.length,
                itemBuilder: (context, index) {
                  return reportItem(taskDetailResponse.report[index]);
                }),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  reportItem(Report report) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    getReportItemIcon(report),
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getReportItemStatus(report),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${report.createdAt}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${report.description}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkIsOwner(TaskDetailResponse taskDetailResponse) {
    if (LoginModel().userDetails.role == "admin") {
      return true;
    } else {
      if (taskDetailResponse.taskDetails != null) {
        if (taskDetailResponse.taskDetails.taskCreatedBy ==
            LoginModel().userDetails.id) {
          return true;
        }
      }
    }
    return false;
  }

  getImage(TaskDetails taskDetails) {
    String img = "";
    if (taskDetails.person != null) {
      if (taskDetails.person.image != null) {
        if (taskDetails.person.image != "") {
          img = taskDetails.person.image;
        }
      }
    }
    return img;
  }

  String getStatus(TaskDetails taskDetails) {
    if (taskDetails.status == 0) {
      return "Completed";
    } else if (taskDetails.status == 1) {
      return "Pending";
    } else if (taskDetails.status == 2) {
      return "Rejected";
    } else if (taskDetails.status == 3) {
      return "Rescheduled";
    }
    else {
      return "Status Unknown";
    }
  }

  getIcon(TaskDetails taskItem) {
    if (taskItem.status == 0) {
      return 'assets/images/ic_complete.png';
    } else if (taskItem.status == 1) {
      return 'assets/images/ic_pending.png';
    } else if (taskItem.status == 2) {
      return 'assets/images/ic_reject.png';
    } else if (taskItem.status == 3) {
      return 'assets/images/ic_rescheduled.png';
    }
    else {
      return 'assets/images/ic_pending.png';
    }
  }

  String getReportItemIcon(Report report) {
    if (report.status == 0) {
      return 'assets/images/ic_complete.png';
    } else if (report.status == 1) {
      return 'assets/images/ic_pending.png';
    } else if (report.status == 2) {
      return 'assets/images/ic_reject.png';
    }  else if (report.status == 3) {
      return 'assets/images/ic_rescheduled.png';
    }
    else {
      return 'assets/images/ic_pending.png';
    }
  }

  String getReportItemStatus(Report report) {
    if (report.status == 0) {
      return "Completed";
    } else if (report.status == 1) {
      return "Pending";
    } else if (report.status == 2) {
      return "Rejected";
    } else if (report.status == 3) {
      return "Rescheduled";
    }
    else {
      return "Status Unknown";
    }
  }

  _buildSalesPersonInfo(TaskDetails taskDetails) {
    if (LoginModel().userDetails.role == "admin") {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              border: Border.all(width: 2, color: Colors.black87),
            ),
            child: ClipOval(
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: getImage(taskDetails),
                  placeholder: (context, url) => Container(
                    child: Center(
                      child: RoundedLoader(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    child: Image(
                      image: AssetImage('assets/images/no_image.png'),
                    ),
                    margin: EdgeInsets.all(5),
                  ),
                ),
              ),
            )),
        title: Text('${taskDetails?.person?.name}',
            style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600)),
        subtitle: Text('Sales Person',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500)),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.black87,
        ),
        onTap: () {
          Get.to(() => SalesPersonDetailsScreen(
            salesPersonId: taskDetails?.person?.id,
            fromPage: FromPage.TaskDetailPage,
          ));
        },
      );
    } else {
      return Container();
    }
  }
}
