import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/TaskOperationsBloc.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Repositories/CommonInfoRepository.dart';
import 'package:sales_manager_app/Screens/drawer/sales_person_list_screen.dart';
import 'package:sales_manager_app/Screens/drawer/showreportscreen.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_card.dart';


class ReportGenerateScreen extends StatefulWidget {
  int user_id;
  ReportGenerateScreen({Key key,this.user_id}) : super(key: key);
  @override
  _ReportGenerateScreenState createState() => _ReportGenerateScreenState();
}

class _ReportGenerateScreenState extends State<ReportGenerateScreen> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  Data1 salesPersonReceived;
  TaskOperationsBloc _taskOperationsBloc;
  File pdf;

  @override
  void initState() {
    super.initState();
    _taskOperationsBloc = TaskOperationsBloc();
  }
  Widget build(BuildContext context) {
    print(widget.user_id);
    return SafeArea(
      child: WillPopScope(
        onWillPop: null,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black12.withOpacity(0.2),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: FractionalOffset.center,
                child: AppCard(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'From',
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dt = await DateHelper.pickDate(
                                            context, _dateTimeFrom);
                                        if (dt != _dateTimeFrom) {
                                          setState(() {
                                            _dateTimeFrom = dt;
                                            print("fromdate--------$_dateTimeFrom");
                                          });
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 13),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(12)),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${DateHelper.formatDateTime(_dateTimeFrom, 'dd-MMM-yyyy')}'),
                                              SizedBox(width: 4),
                                              Icon(
                                                CupertinoIcons.calendar,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'To',
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dt = await DateHelper.pickDate(
                                            context, _dateTimeTo);
                                        if (dt != _dateTimeTo) {
                                          setState(() {
                                            _dateTimeTo = dt;
                                            print("To date---->$_dateTimeTo");
                                          });
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 13),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(12)),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${DateHelper.formatDateTime(_dateTimeTo, 'dd-MMM-yyyy')}'),
                                              SizedBox(width: 4),
                                              Icon(
                                                CupertinoIcons.calendar,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Visibility(
                            child: Text(
                              'Sales Person',
                              style: TextStyle(color: Colors.black45),
                            ),
                            visible: LoginModel().userDetails.role == "admin"
                                ? true
                                : false,
                          ),
                          _buildAddSalesPerson(),
                          Visibility(
                            child: Divider(),
                            visible: LoginModel().userDetails.role == "admin"
                                ? true
                                : false,
                          ),
                          GestureDetector(
                            onTap: ()async{
                              if (LoginModel().userDetails.role == "admin") {
                                pdf =
                                await _taskOperationsBloc.reportGenerate(salesPersonReceived.id,_dateTimeFrom,_dateTimeTo);
                              }
                              else
                              pdf =
                              await _taskOperationsBloc.reportGenerate(widget.user_id,_dateTimeFrom,_dateTimeTo);
                              // _reportTaskFunction();
                              // _reportrepository.getpdfofreport();

                              // launchUrlString("http://www.africau.edu/images/default/sample.pdf");
                              // // var url = 'http://www.africau.edu/images/default/sample.pdf';
                              // // launch(url, forceWebView: true);
                              Get.to(ShowReportScreen(pdf: pdf));
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:Color(buttonBgColor),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Download",style: TextStyle(color: Colors.white ),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.file_download,color: Colors.white,size: 25,)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                            alignment: FractionalOffset.center,
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                ),
                              ),
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _reportTaskFunction() {
  //   var resBody = {};
  //   resBody["salesman_id"] = 66;
  //   resBody["from_date"] = "${DateHelper.formatDateTime(_dateTimeFrom, 'yyyy-MM-dd')}";
  //   resBody["to_date"] = "${DateHelper.formatDateTime(_dateTimeTo, 'yyyy-MM-dd')}";
  //   CommonWidgets().showNetworkProcessingDialog();
  //   _taskOperationsBloc.reportgenerate(json.encode(resBody))
  //       .then((value) async {
  //     Get.back();
  //     CommonSuccessResponse response = value;
  //     print("valueeeeee----$value");
  //     print("response->$response");
  //     if (response.success) {
  //       Fluttertoast.showToast(
  //           msg: response.message ?? "Task Updated successfully");
  //       Map<String, dynamic> data = Map();
  //       data.assign('taskUpdated', true);
  //       Get.back(result: data);
  //     } else {
  //       Fluttertoast.showToast(msg: response.message);
  //     }
  //   }).catchError((err) {
  //     Get.back();
  //     CommonWidgets().showNetworkErrorDialog(err.toString());
  //   });
  // }

  _buildAddSalesPerson() {
    if (LoginModel().userDetails.role == "admin") {
      if (salesPersonReceived != null) {
        return ListTile(
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
                        image: AssetImage('assets/images/no_image.png'),
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
        );
      } else {
        return ListTile(
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
                fromPage: FromPage.ReportFilterPage,
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
}
