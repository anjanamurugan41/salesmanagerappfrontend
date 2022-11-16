import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/CommonInfoBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/LoginResponse.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/ForgotPasswordScreen.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/RegisterScreen.dart';
import 'package:sales_manager_app/Screens/home/home_screen.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/Utilities/PreferenceUtils.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DateTime currentBackPressTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userName;
  String _password;
  int _id;
  bool _obscurePasswordText = true;
  CommonInfoBloc _commonInfoBloc;

  @override
  void initState() {
    super.initState();
    _commonInfoBloc = CommonInfoBloc();
  }

  void _togglePassword() {
    setState(() {
      _obscurePasswordText = !_obscurePasswordText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: StringConstants.doubleBackExit);
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(colorCodePageBgGradient1),
                    const Color(colorCodePageBgGradient2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(_blankFocusNode);
              },
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Log In",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25,
                                color: Color(colorCodeBlack),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Email",
                              maxLinesReceived: 1,
                              maxLengthReceived: 60,
                              isEmail: true,
                              textColorReceived: Color(textFieldColor),
                              fillColorReceived: Color(textFieldBgColor),
                              hintColorReceived: Color(textFieldLabelColor),
                              borderColorReceived: Color(textFieldBorderColor),
                              onChanged: (val) => _userName = val,
                              validator: CommonMethods().emailValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Password",
                              maxLinesReceived: 1,
                              maxLengthReceived: 8,
                              isPassword: true,
                              textColorReceived: Color(textFieldColor),
                              fillColorReceived: Color(textFieldBgColor),
                              hintColorReceived: Color(textFieldLabelColor),
                              borderColorReceived: Color(textFieldBorderColor),
                              obscureText: _obscurePasswordText,
                              suffixIcon: IconButton(
                                onPressed: _togglePassword,
                                icon: Icon(
                                  _obscurePasswordText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                              ),
                              onChanged: (val) => _password = val,
                              validator: CommonMethods().passwordValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CommonButton(
                                buttonText: "Forgot Password?",
                                bgColorReceived: Colors.transparent,
                                borderColorReceived: Colors.transparent,
                                textColorReceived: Color(colorCodeBlack),
                                buttonHandler: goToForgotPassword)
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: CommonButton(
                              buttonText: " Log In ",
                              bgColorReceived: Color(buttonBgColor),
                              borderColorReceived: Color(buttonBgColor),
                              textColorReceived: Color(colorCodeWhite),
                              buttonHandler: validateLogin),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: CommonButton(
                              buttonText: " Register As Manager",
                              bgColorReceived: Color(colorCodeWhite),
                              borderColorReceived: Color(buttonBgColor),
                              textColorReceived: Color(buttonBgColor),
                              buttonHandler: () {
                                Get.offAll(RegisterScreen());
                              }),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateLogin() {
    if (_formKey.currentState.validate()) {
      print("Login api call");
      print(_userName);
      print(_password);
      print("***");
      callLogin();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  goToForgotPassword() {
    Get.to(() => ForgotPassword());
  }

  void callLogin() {
    CommonWidgets().showNetworkProcessingDialog();
    var resBody = {};
    resBody["email"] = _userName;
    resBody["password"] = _password;
    resBody["id"]=_id;
    _commonInfoBloc.userLogin(json.encode(resBody)).then((value) {
      Get.back();
      LoginResponse loginResponse = value;
      if (loginResponse.success) {
        LoginModel().authToken = loginResponse.accessToken;
        LoginModel().userDetails = loginResponse.userInfo;
        PreferenceUtils.setStringToSF(
            PreferenceUtils.prefAuthToken, loginResponse.accessToken);
        PreferenceUtils.setBoolToSF(PreferenceUtils.prefIsLoggedIn, true);
        PreferenceUtils.setObjectToSF(
            PreferenceUtils.prefUserDetails, loginResponse.userInfo);
        Get.offAll(() => HomeScreen());
      } else {
        Fluttertoast.showToast(
            msg: loginResponse.message ??
                "Something went wrong, please try again later");
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err.toString());
    });
  }
}
