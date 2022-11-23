import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
import 'package:sales_manager_app/Screens/drawer/sales_person_list_screen.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';
import 'package:sales_manager_app/widgets/app_button.dart';

import 'SelectDateTimeScreen.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SalesPersonInfo salesPersonReceived;

  TaskOperationsBloc _taskOperationsBloc;
  bool isTaskCreated = false;

  @override
  void initState() {
    super.initState();
    _taskOperationsBloc = TaskOperationsBloc();
  }

  void _backPressFunction() {
    print("clicked");
    if (isTaskCreated) {
      CommonMethods().tasksListUpdated();
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
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
              children: [
                Expanded(
                  child: CommonAppBar(
                    text: "",
                    buttonHandler: _backPressFunction,
                  ),
                  flex: 1,
                ),
                AppButton.text(
                  text: 'Done',
                  onTap: validateSave,
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
                        _buildAddSalesPerson(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                      ],
                    ),
                  )),
            ),
          )),
    ));
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
                  maxLinesReceived: 2,
                  minLinesReceived: 1,
                  maxLengthReceived: 100,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  controller: _titleController,
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
                  maxLinesReceived: 1,
                  maxLengthReceived: 60,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  controller: _clientNameController,
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
                  maxLinesReceived: 4,
                  minLinesReceived: 2,
                  maxLengthReceived: 200,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  controller: _addressController,
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
                  maxLinesReceived: 7,
                  minLinesReceived: 2,
                  maxLengthReceived: 700,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  controller: _descriptionController,
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
            hidePreviousDates: true,
            initDate: DateTime.now(),
            isFromUpdateTask: false,
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
            onTap: () {
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
                    Text('${DateHelper.formatDateTime(_dateTime,'dd-MMM-yyyy')}'),
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


  _buildAddSalesPerson() {
    if (LoginModel().userDetails.role == "admin") {
      if (salesPersonReceived != null) {
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Assigned to',
                    style: TextStyle(color: Colors.black45),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 2), // changes position of shadow
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black12.withOpacity(0.05),
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
                                  image:
                                      AssetImage('assets/images/no_image.png'),
                                ),
                                margin: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      "${salesPersonReceived.name}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Color(colorCodeBlack),
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: AppButton.elevated(
                      text: salesPersonReceived != null ? "Change" : "Add",
                      onTap: () async {
                        Map<String, dynamic> data =
                            await Get.to(() => SalesPersonListScreen(
                                  isToSelectPerson: true,
                                  fromPage: FromPage.CreateTaskPage,
                                ));

                        if (data != null && mounted) {
                          if (data.containsKey("selectedPersonInfo")) {
                            setState(() {
                              salesPersonReceived = data["selectedPersonInfo"];
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Assigned to',
                    style: TextStyle(color: Colors.black45),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          border: Border.all(width: 2, color: Colors.black87),
                        ),
                        child: Image.asset('assets/images/ic_avatar.png')),
                    title: Text('Add Person'),
                    trailing: AppButton.elevated(
                      text: 'Add',
                      onTap: () async {
                        Map<String, dynamic> data =
                            await Get.to(() => SalesPersonListScreen(
                                  isToSelectPerson: true,
                                  fromPage: FromPage.CreateTaskPage,
                                ));

                        if (data != null && mounted) {
                          if (data.containsKey("selectedPersonInfo")) {
                            setState(() {
                              salesPersonReceived = data["selectedPersonInfo"];
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      return Container();
    }
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
      if (LoginModel().userDetails.role == "admin") {
        if (salesPersonReceived != null) {
          _createTaskFunction();
        } else {
          Fluttertoast.showToast(msg: "Please select a sales person");
        }
      } else {
        _createTaskFunction();
      }
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void _createTaskFunction() {
    var resBody = {};
    resBody["title"] = _title.trim();
    resBody["clientname"] = _clientName.trim();
    resBody["description"] = _description.trim();
    resBody["address"] = _address.trim();
    resBody["date"] = "${DateHelper.formatDateTime(_dateTime, 'dd-MM-yyyy')}";
    resBody["time"] = "${DateHelper.formatDateTime(_timeInfo, 'hh:mm a')}";
    // resBody["managername"]=;
    if (LoginModel().userDetails.role == "admin") {
      resBody["user_id"] = salesPersonReceived.id;
    } else {
      resBody["user_id"] = LoginModel().userDetails.id;
    }
    CommonWidgets().showNetworkProcessingDialog();
    _taskOperationsBloc.createNewTask(json.encode(resBody)).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        isTaskCreated = true;
        Fluttertoast.showToast(
            msg: response.message ?? "Task Created successfully");
        //clearFields();
        _backPressFunction();
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err.toString());
    });
  }

  void clearFields() {
    _titleController.text = "";
    _clientNameController.text = "";
    _addressController.text = "";
    _descriptionController.text = "";
    _dateTime = DateTime.now();
    salesPersonReceived = null;
    setState(() {});
  }
}
