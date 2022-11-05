import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


// MaterialColor primaryColor = MaterialColor(int.parse("0xffd0006f"), {
//   50:  Color(0xfffde5f0),
//   100: Color(0xfffabdd9),
//   200: Color(0xfff991c0),
//   300: Color(0xfff962a5),
//   400: Color(0xfff83c8f),
//   500: Color(0xfff90079),
//   600: Color(0xffe70075),
//   700: Color(0xffd0006f),
//   800: Color(0xffba006a),
//   900: Color(0xff940062),
// });
// MaterialColor secondaryColor = MaterialColor(int.parse("0xff02075f"),{
// 50: Color(0xffe5e6f2),
// 100: Color(0xffbebfde),
// 200: Color(0xff9396c7),
// 300: Color(0xff696eb1),
// 400: Color(0xff4b50a2),
// 500: Color(0xff2c3393),
// 600: Color(0xff272c8a),
// 700: Color(0xff1e237f),
// 800: Color(0xff151a73),
// 900: Color(0xff02075f),
// });

  double screenWidth=0.0;
  double screenHeight=0.0;

  String rupeeSymbol = '₹';

  void setScreenDimensions(BuildContext context){
    screenHeight= MediaQuery.of(context).size.height;
    screenWidth=MediaQuery.of(context).size.width;
  }

  void toastMessage(dynamic message,{ToastGravity gravity=ToastGravity.BOTTOM}){
    log('toast: $message');
    Fluttertoast.showToast(msg: '$message',gravity: gravity);
  }
