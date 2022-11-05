import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager_app/Blocs/TaskOperationsBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/TaskDetailResponse.dart';
import 'package:sales_manager_app/Screens/drawer/sales_person_list_screen.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';
import 'package:sales_manager_app/widgets/app_button.dart';

import 'SelectDateTimeScreen.dart';

class UpdateTaskScreen extends StatefulWidget {
  TaskDetails taskDetails;

  UpdateTaskScreen({Key key, this.taskDetails}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  String _title;
  String _clientName;
  String _address;
  String _description;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _clientNameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  DateTime _dateTime = DateTime.now();
  DateTime _timeInfo = DateTime.now();
  DateTime _currentTime = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SalesPersonInfo salesPersonReceived;
  TaskOperationsBloc _taskOperationsBloc;

  @override
  void initState() {
    super.initState();
    initValues();
    _taskOperationsBloc = TaskOperationsBloc();
  }

  void initValues() {
    if (widget.taskDetails != null) {
      _titleController.text = widget.taskDetails.title;
      _title = widget.taskDetails.title;

      _clientNameController.text = widget.taskDetails.clientname;
      _clientName = widget.taskDetails.clientname;

      _addressController.text = widget.taskDetails.address;
      _address = widget.taskDetails.address;

      _descriptionController.text = widget.taskDetails.description;
      _description = widget.taskDetails.description;

      try {
        _dateTime = DateFormat('yyyy-MM-dd hh:mm a')
            .parse('${widget.taskDetails.date} ${widget.taskDetails.time}');
        _timeInfo = DateFormat('yyyy-MM-dd hh:mm a')
            .parse('${widget.taskDetails.date} ${widget.taskDetails.time}');
        print("***");
        print(_dateTime);
        print("***");
      } catch (e) {}
    } else {
      _dateTime = DateTime.now();
      _timeInfo = DateTime.now();
    }
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // here the desired height
            child: Row(
              children: [
                Expanded(
                  child: CommonAppBar(
                    text: "",
                    buttonHandler: _backPressFunction,
                  ),
                  flex: 1,
                ),
                AppButton.text(
                  text: 'Update',
                  onTap: () {
                    validateSave();
                  },
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(_blankFocusNode);
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            'Add New Task',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        _buildInputSection(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                      ],
                    ),
                  )),
            ),
          )),
    );
  }

  _buildInputSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Title',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Title",
                  controller: _titleController,
                  maxLinesReceived: 2,
                  minLinesReceived: 1,
                  maxLengthReceived: 100,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _title = val,
                  validator: CommonMethods().requiredValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Client Name',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Client Name",
                  controller: _clientNameController,
                  maxLinesReceived: 1,
                  maxLengthReceived: 60,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _clientName = val,
                  validator: CommonMethods().requiredValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            _buildDateTime(),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Address',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Type Address",
                  controller: _addressController,
                  maxLinesReceived: 4,
                  minLinesReceived: 2,
                  maxLengthReceived: 200,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _address = val,
                  validator: CommonMethods().requiredValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Description',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Write Something",
                  controller: _descriptionController,
                  maxLinesReceived: 7,
                  minLinesReceived: 2,
                  maxLengthReceived: 700,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _description = val,
                  validator: CommonMethods().requiredValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
          ],
        ),
      ),
    );
  }

  void showDateTimeScreen(var selectionType) async {
    Map<String, dynamic> data = await Get.to(
        () => SelectDateTimeScreen(
            hidePreviousDates: false,
            initDate: _currentTime,
            isFromUpdateTask: true,
            currentlySelectedDate: _dateTime,
            selectionType: selectionType),
        opaque: false,
        fullscreenDialog: true);

    if (data != null && mounted) {
      if (data.containsKey("isDateTimeSelected")) {
        if (data["isDateTimeSelected"]) {
          if (data.containsKey("dateSelected")) {
            _dateTime = data['dateSelected'];
            if (!_dateTime.isAfter(DateTime.now())) {
              _timeInfo = DateTime.now();
            }
          }

          if (data.containsKey("timeSelected")) {
            DateTime temp = data['timeSelected'];
            _timeInfo = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
                temp.hour, temp.minute);
          }

          setState(() {});
        }
      }
    }
  }

  _buildDateTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();
              showDateTimeScreen(DateSelectionType.SelectDate);
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${DateHelper.formatDateTime(_dateTime, 'dd-MMM-yyyy')}'),
                    SizedBox(width: 3),
                    Icon(
                      CupertinoIcons.calendar,
                      color: Colors.black54,
                    ),
                  ],
                )),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              FocusScope.of(context).unfocus();
              showDateTimeScreen(DateSelectionType.SelectTime);
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${DateHelper.formatDateTime(_timeInfo, 'hh:mm a')}'),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.time,
                      color: Colors.black54,
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  getImage() {
    String img = "";
    if (salesPersonReceived != null) {
      if (salesPersonReceived.image != null) {
        if (salesPersonReceived.image != "") {
          img = salesPersonReceived.image;
        }
      }
    }
    return img;
  }

  validateSave() {
    if (_formKey.currentState.validate()) {
      _updateTaskFunction();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void _updateTaskFunction() {
    var resBody = {};
    resBody["title"] = _title.trim();
    resBody["clientname"] = _clientName.trim();
    resBody["description"] = _description.trim();
    resBody["address"] = _address.trim();
    resBody["date"] = "${DateHelper.formatDateTime(_dateTime, 'dd-MM-yyyy')}";
    resBody["time"] = "${DateHelper.formatDateTime(_timeInfo, 'hh:mm a')}";
    resBody["user_id"] = widget.taskDetails.person.id;
    CommonWidgets().showNetworkProcessingDialog();
    _taskOperationsBloc
        .updateTask(json.encode(resBody), widget.taskDetails.id)
        .then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        Fluttertoast.showToast(
            msg: response.message ?? "Task Updated successfully");
        Map<String, dynamic> data = Map();
        data.assign('taskUpdated', true);
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
