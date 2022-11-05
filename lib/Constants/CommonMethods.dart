import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Interfaces/RefreshPageListener.dart';
import '../Utilities/LoginModel.dart';
import 'CustomColorCodes.dart';
import 'StringConstants.dart';

class CommonMethods {
  static RefreshPageListener _refreshFilterPageListener , _refreshDashboardListener;

  void setRefreshFilterPageListener(RefreshPageListener listener) {
    print("initialized#####");
    _refreshFilterPageListener = listener;
  }

  void setRefreshDashboardListener(RefreshPageListener listener) {
    print("initialized#####");
    _refreshDashboardListener = listener;
  }

  void tasksListUpdated() {
    print("*****refresh view all page ");
    if (_refreshDashboardListener != null) {
      _refreshDashboardListener.refreshPage();
    }
  }

  String getNetworkError(error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = StringConstants.dioErrorTypeCancel;
          break;
        case DioErrorType.connectTimeout:
          errorDescription = StringConstants.dioErrorTypeConnectTimeout;
          break;
        case DioErrorType.other:
          errorDescription = StringConstants.dioErrorTypeDefault;
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = StringConstants.dioErrorTypeReceiveTimeout;
          break;
        case DioErrorType.response:
          errorDescription = StringConstants.dioErrorTypeResponse;
          break;
        case DioErrorType.sendTimeout:
          errorDescription = StringConstants.dioErrorTypeSendTimeout;
          break;
      }
    } else {
      errorDescription = StringConstants.normalErrorMessage;
    }

    return errorDescription;
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// My way of capitalizing each word in a string.
  String titleCase(String text) {
    if (text == null) return "";

    if (text.isEmpty) return text;

    /// If you are careful you could use only this part of the code as shown in the second option.
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String changeDateFormat(String dateReceived) {
    String dateFormat = "";
    try {
      if (dateReceived != null && dateReceived != "") {
        dateFormat =
            DateFormat("dd MMM yyyy").format(DateTime.parse(dateReceived));
      }
      return dateFormat;
    } catch (e) {
      return "";
    }
  }

  String changeTimeFormat(String dateReceived) {
    String dateFormat = "";
    try {
      if (dateReceived != null && dateReceived != "") {
        dateFormat = DateFormat("HH:mm a").format(DateTime.parse(dateReceived));
      }
      return dateFormat;
    } catch (e) {
      return "";
    }
  }

  String getDateTime(String dateReceived) {
    String dateFormat = "";
    try {
      if (dateReceived != null && dateReceived != "") {
        dateFormat = DateFormat("dd MMM yyyy HH:mm a")
            .format(DateTime.parse(dateReceived));
      }
      return dateFormat;
    } catch (e) {
      return "";
    }
  }

  checkNetworkConnection() {
    CommonMethods().isInternetAvailable().then((onValue) {
      if (!onValue) {
        LoginModel().isNetworkAvailable = false;

        Get.snackbar("Oops!!", "${StringConstants.netFailureMsg}",
            backgroundColor: Color(colorCodeGreyPageBg),
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            shouldIconPulse: true,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            icon: Icon(
              Icons.wifi_off,
              color: Colors.red,
            ));
      } else {
        LoginModel().isNetworkAvailable = true;
      }
    });
  }

  clearData() async {
    LoginModel().clearInfo();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    Get.offAll(() => LoginScreen());
  }

  bool isAuthTokenExist() {
    if (LoginModel().authToken != null) {
      if (LoginModel().authToken != "") {
        return true;
      }
    }
    return false;
  }

  String readTimestamp(String dateReceived) {
    try {
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.now();
      var diff = dateTimeNow.difference(dateTimeCreatedAt);
      var time = '';

      if (diff.inSeconds <= 0 ||
          diff.inSeconds > 0 && diff.inMinutes == 0 ||
          diff.inMinutes > 0 && diff.inHours == 0 ||
          diff.inHours > 0 && diff.inDays == 0) {
        time = DateFormat("hh:mm:ss a").format(dateTimeCreatedAt);
      } else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = diff.inDays.toString() + ' DAY AGO';
        } else {
          time = diff.inDays.toString() + ' DAYS AGO';
        }
      } else {
        if (diff.inDays == 7) {
          time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
        } else {
          time = DateFormat("dd MMM yyyy").format(dateTimeCreatedAt);
        }
      }

      return time;
    } catch (e) {
      return dateReceived;
    }
  }

  String validateMobile(String phone) {
    if (phone.length == 0) {
      return "Enter mobile number";
    } else if (phone.length < 7) {
      return "Please provide a valid mobile number";
    }
    return null;
  }

  String nameValidator(String name) {
    if (name.length == 0) {
      return "Enter name";
    } else if (name.length < 3) {
      return "Please provide a valid name";
    }
    return null;
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return "Enter an email address";
    if (!regex.hasMatch(value))
      return "Please provide a valid email";
    else
      return null;
  }

  String requiredValidator(String name) {
    if (name.length == 0) {
      return "Required field";
    }
    return null;
  }

  alertLoginOkClickFunction() {
    print("_alertOkBtnClickFunction clicked");
    //Get.offAll(() => LoginScreen());
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }


  String getDateDifference(String dateReceived) {
    try {
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.now();
      final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
      print('$differenceInDays');
      if (differenceInDays > 1) {
        return "$differenceInDays Days left";
      } else if (differenceInDays == 0) {
        return "Last Date";
      } else {
        return "$differenceInDays Day left";
      }
    } catch (e) {
      return "";
    }
  }

  String getDateGap(String dateReceived) {
    try {
      DateTime dateTimeCreatedAt = DateTime.parse(dateReceived);
      DateTime dateTimeNow = DateTime.now();
      final differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
      print('$differenceInDays');
      return '$differenceInDays';
    } catch (e) {
      return "";
    }
  }

  /*

  r'^
  (?=.*[A-Z])       // should contain at least one upper case
  (?=.*[a-z])       // should contain at least one lower case
  (?=.*?[0-9])      // should contain at least one digit
  (?=.*?[!@#\$&*~]) // should contain at least one Special character
  .{8,}             // Must be at least 8 characters in length
   $
   */
  /*String passwordValidator(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return "Password is mandatory";
    if (!regex.hasMatch(value)) {
      var msg =
          ''' Should contain 8 characters with at least one upper case, lower case, one digit and one Special character ''';
      return msg;
    } else {
      return null;
    }
  }*/

  String passwordValidator(String value) {
    if (value.isEmpty) return "Password is mandatory";
    if (value.length<3) {
      var msg =
      ''' Must be 6 characters long ''';
      return msg;
    } else {
      return null;
    }
  }
}
