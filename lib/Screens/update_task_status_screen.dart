import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/TaskOperationsBloc.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_icon.dart';
import 'package:sales_manager_app/widgets/app_text_box.dart';

class UpdateTaskStatusScreen extends StatefulWidget {
  int taskId;
  int salesManId;

  UpdateTaskStatusScreen({Key key, this.taskId, this.salesManId})
      : super(key: key);

  @override
  _UpdateTaskStatusScreenState createState() => _UpdateTaskStatusScreenState();
}

class _UpdateTaskStatusScreenState extends State<UpdateTaskStatusScreen> {
  String _description;

  String _status; //='-Select-';
  TaskOperationsBloc _taskOperationsBloc;

  @override
  void initState() {
    super.initState();
    _taskOperationsBloc = TaskOperationsBloc();
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
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: CommonAppBar(
            text: "Change Status",
            buttonHandler: _backPressFunction,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Text(
              'Update Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black45),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        hint: Text('- select -'),
                        value: _status,
                        items: <String>['Completed', 'Pending', 'Rejected', "rescheduled"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _status = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .01),
                    Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black45),
                    ),
                    Padding(
                      child: CommonTextFormField(
                          hintText: "Write Something",
                          maxLinesReceived: 7,
                          minLinesReceived: 3,
                          maxLengthReceived: 700,
                          isEmail: false,
                          textColorReceived: Colors.black,
                          fillColorReceived: Colors.transparent,
                          hintColorReceived: Colors.black45,
                          borderColorReceived: Colors.black45,
                          onChanged: (val) => _description = val),
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                  ],
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: CommonButton(
                  buttonText: "Update",
                  bgColorReceived: Color(buttonBgColor),
                  borderColorReceived: Color(buttonBgColor),
                  textColorReceived: Color(colorCodeWhite),
                  buttonHandler: validateForm),
            )
          ],
        ),
      ),
    );
  }

  validateForm() {
    if (_status != null && _status.isNotEmpty) {
      if (_description != null && _description.isNotEmpty) {
        changeStatus();
      } else {
        Fluttertoast.showToast(msg: "Please provide your comments");
      }
    } else {
      Fluttertoast.showToast(msg: "Please select any status");
    }
  }

  void changeStatus() {
    var resBody = {};
    resBody["task"] = widget.taskId;
    resBody["status"] = _status;
    resBody["description"] = _description.trim();
    resBody["salesman"] = widget.salesManId;

    CommonWidgets().showNetworkProcessingDialog();
    _taskOperationsBloc.updateTaskStatus(json.encode(resBody)).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        Map<String, dynamic> data = HashMap();
        data.assign('taskStatusUpdated', true);
        Get.back(result: data);
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err.toString());
    });
  }
}
