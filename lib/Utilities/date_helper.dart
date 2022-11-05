import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper{
  static String formatDateTime(DateTime dt, String format){
    return DateFormat(format).format(dt);
  }
  static DateTime getDateTime(String datetime){
    return DateTime.parse(datetime);
  }
  static DateTime getDate(DateTime dt){
    return DateTime(dt.year,dt.month,dt.day);
  }


  static Future<DateTime> pickDate(BuildContext context, DateTime initDate,
      {bool hidePreviousDates = false}) async {
    DateTime cDate=initDate;
    await showModalBottomSheet(context: context, builder: (context){
      return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Choose Date',
              style: TextStyle( fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: cDate,
              minimumDate: hidePreviousDates ? cDate : null,
              onDateTimeChanged: (DateTime dateTime) {
                cDate = dateTime;
              },
            ),
          ),
        ],
      );
    });
    return cDate;
  }

  static Future<DateTime> pickTime(BuildContext context, DateTime initDate,
      {bool hidePreviousDates}) async {
    DateTime cDate=initDate;
    await showModalBottomSheet(context: context, builder: (context){
      return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Choose Time',
              style: TextStyle( fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: cDate,
              minimumDate: hidePreviousDates ? cDate : null,
              onDateTimeChanged: (DateTime dateTime) {
                cDate = dateTime;
              },
            ),
          ),
        ],
      );
    });
    return cDate;
  }
}

