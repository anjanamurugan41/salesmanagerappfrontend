import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';

class SelectDateTimeScreen extends StatefulWidget {
  bool hidePreviousDates;
  DateTime initDate;
  DateTime currentlySelectedDate;
  bool isFromUpdateTask;
  var selectionType;

  SelectDateTimeScreen(
      {Key key,
      this.hidePreviousDates,
      this.initDate,
      this.isFromUpdateTask,
      this.selectionType,
      this.currentlySelectedDate})
      : super(key: key);

  @override
  _SelectDateTimeScreenState createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime cDate;

  @override
  void initState() {
    super.initState();
    cDate = widget.initDate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: null,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black12.withOpacity(0.2),
          body: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                flex: 1,
              ),
              _buildDateTimePicker()
            ],
          ),
        ),
      ),
    );
  }

  _buildDateTimePicker() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8, 10, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
                Text(
                  widget.selectionType == DateSelectionType.SelectDate
                      ? 'Choose Date'
                      : 'Choose Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                    child: Text(
                      'Ok',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  onTap: () async {
                    Map<String, dynamic> data = new Map();
                    data['isDateTimeSelected'] = true;
                    if (widget.selectionType == DateSelectionType.SelectDate) {
                      data['dateSelected'] = cDate;
                      Get.back(result: data);
                    } else if (widget.selectionType ==
                        DateSelectionType.SelectTime) {
                      print("******dates");
                      print("${widget.currentlySelectedDate}");
                      print("${widget.initDate}");
                      print("$cDate");
                      print("******");
                      if (cDate.isAfter(widget.initDate)) {
                        print("******15");
                        data['timeSelected'] = cDate;
                        Get.back(result: data);
                      } else {
                        if (widget.currentlySelectedDate
                            .isAfter(widget.initDate)) {
                          print("******16");
                          data['timeSelected'] = cDate;
                          Get.back(result: data);
                        } else {
                          print("******17");
                          Fluttertoast.showToast(msg: "Please Choose a Future Date and Time");
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: widget.selectionType == DateSelectionType.SelectDate
                  ? CupertinoDatePickerMode.date
                  : CupertinoDatePickerMode.time,
              initialDateTime: widget.initDate,
              minimumDate: getMinimumDate(),
              onDateTimeChanged: (DateTime dateTime) {
                cDate = dateTime;
              },
            ),
          ),
        ],
      ),
    );
  }

  getMinimumDate() {
    if (widget.selectionType == DateSelectionType.SelectDate) {
      return widget.initDate;
    }

    return null;
  }
}
