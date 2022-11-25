import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Screens/drawer/sales_person_list_screen.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/Utilities/date_helper.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_card.dart';

class ReportFilterScreen extends StatefulWidget {
  @override
  _ReportFilterScreenState createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  DateTime _dateTimeFrom = DateTime.now();
  DateTime _dateTimeTo = DateTime.now();
  String _status = 'Completed';
  SalesPersonInfo salesPersonReceived;

  @override
  Widget build(BuildContext context) {
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
                          //todo change calendar, clock icons
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
                      Text(
                        'Filter',
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
                          value: _status,
                          items: <String>['Completed', 'Pending', 'Rejected',"Rescheduled"]
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
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: CommonButton(
                            buttonText: " Apply ",
                            bgColorReceived: Color(buttonBgColor),
                            borderColorReceived: Color(buttonBgColor),
                            textColorReceived: Color(colorCodeWhite),
                            buttonHandler: applyFilter),
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

  applyFilter() {
    Map<String, dynamic> data = new HashMap();
    data['isFilterApplied'] = true;
    data['taskStatus'] = _status;
    data['startDate'] = DateHelper.formatDateTime(_dateTimeFrom, 'dd-MM-yyyy');
    data['endDate'] = DateHelper.formatDateTime(_dateTimeTo, 'dd-MM-yyyy');
    if (salesPersonReceived != null &&
        LoginModel().userDetails.role == "admin") {
      data['salesPersonId'] = salesPersonReceived.id;
    }
    Get.back(result: data);
  }

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
