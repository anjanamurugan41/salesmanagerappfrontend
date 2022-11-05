import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/Utilities/PreferenceUtils.dart';
import 'package:sales_manager_app/Utilities/app_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthorisationScreens/LoginScreen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String authToken;
  UserDetails userDetails;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setScreenDimensions(context);
      setState(() {});
    });
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              const Color(colorCodeWhite),
              const Color(colorCodeWhite),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/ic_logo01.png',
                fit: BoxFit.fill,
                //height: MediaQuery.of(context).size.height * .40,
                width: MediaQuery.of(context).size.width * .50,
              ),
            ),
          ),
          Text(
            'Powered by',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
          ),
          SizedBox(height: 8),
          Text(
            'Cocoalabs India Pvt Ltd',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    ));
  }

  void getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      authToken = prefs.getString(PreferenceUtils.prefAuthToken) ?? "";
      print(authToken);
      if (authToken != "") {
        var data = prefs.getString(PreferenceUtils.prefUserDetails) ?? "";
        if (data != "") {
          userDetails = UserDetails.fromJson(json.decode(data));
          if (userDetails != null) {
            LoginModel().authToken = authToken;
            LoginModel().userDetails = userDetails;
            print("*************************");
            print(userDetails.id);
            print(userDetails.name);
            print(userDetails.email);
            print("*************************");
          } else {
            print("*******");
            print("userDetails is null");
            print("*******");
          }
        } else {
          print("*******");
          print("data is empty");
          print("*******");
        }
      } else {
        print("*******");
        print("auth is empty");
        print("*******");
      }
      startTime();
    } catch (Exception) {
      startTime();
    }
  }

  startTime() async {
    print("****");
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigateToStartUp);
  }

  void navigateToStartUp() {
    if (LoginModel().authToken != null && LoginModel().authToken != "") {
      Get.offAll(() => HomeScreen(), transition: Transition.fade);
    } else {
      Get.offAll(() => LoginScreen(), transition: Transition.fade);
    }
  }
}
