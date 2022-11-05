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
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/ForgotPasswordScreen.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime currentBackPressTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _phone;
  String _userTypedNewPassword;
  String _userTypedConfirmPassword;
  bool _obscureNewPasswordText = true;
  bool _obscureConfirmPasswordText = true;
  CommonInfoBloc _commonInfoBloc;

  @override
  void initState() {
    super.initState();
    _commonInfoBloc = CommonInfoBloc();
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureNewPasswordText = !_obscureNewPasswordText;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPasswordText = !_obscureConfirmPasswordText;
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
                            "Register",
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
                              hintText: "Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 60,
                              isEmail: false,
                              textColorReceived: Color(textFieldColor),
                              fillColorReceived: Color(textFieldBgColor),
                              hintColorReceived: Color(textFieldLabelColor),
                              borderColorReceived: Color(textFieldBorderColor),
                              onChanged: (val) => _name = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
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
                              onChanged: (val) => _email = val,
                              validator: CommonMethods().emailValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Phone",
                              maxLinesReceived: 1,
                              maxLengthReceived: 15,
                              isDigitsOnly: true,
                              textColorReceived: Color(textFieldColor),
                              fillColorReceived: Color(textFieldBgColor),
                              hintColorReceived: Color(textFieldLabelColor),
                              borderColorReceived: Color(textFieldBorderColor),
                              onChanged: (val) => _phone = val,
                              validator: CommonMethods().validateMobile ),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "New Password",
                              maxLinesReceived: 1,
                              maxLengthReceived: 8,
                              isPassword: true,
                              textColorReceived: Color(textFieldColor),
                              fillColorReceived: Color(textFieldBgColor),
                              hintColorReceived: Color(textFieldLabelColor),
                              borderColorReceived: Color(textFieldBorderColor),
                              obscureText: _obscureNewPasswordText,
                              onChanged: (val) =>
                              _userTypedNewPassword = val,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _toggleNewPassword();
                                },
                                icon: Icon(
                                  _obscureNewPasswordText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                              ),
                              validator: _validateUserNewPassword),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height:
                            MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              hintText: "Confirm Password",
                              maxLinesReceived: 1,
                              maxLengthReceived: 8,
                              isPassword: true,
                              textColorReceived: Color(textFieldColor),
                              fillColorReceived: Color(textFieldBgColor),
                              hintColorReceived: Color(textFieldLabelColor),
                              borderColorReceived: Color(textFieldBorderColor),
                              obscureText: _obscureConfirmPasswordText,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _toggleConfirmPassword();
                                },
                                icon: Icon(
                                  _obscureConfirmPasswordText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                              ),
                              onChanged: (val) =>
                              _userTypedConfirmPassword = val,
                              validator: _validateUserConfirmPassword),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: CommonButton(
                              buttonText: " Sign Up ",
                              bgColorReceived: Color(buttonBgColor),
                              borderColorReceived: Color(buttonBgColor),
                              textColorReceived: Color(colorCodeWhite),
                              buttonHandler: validateSignUp),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .02),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: CommonButton(
                              buttonText: " Login ",
                              bgColorReceived: Color(colorCodeWhite),
                              borderColorReceived: Color(buttonBgColor),
                              textColorReceived: Color(buttonBgColor),
                              buttonHandler: (){
                                Get.offAll(LoginScreen());
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

  String _validateUserNewPassword(String newPasssword) {
    if (newPasssword.length == 0) {
      return 'New password can\'t be empty';
    } else if (newPasssword.length > 0 && newPasssword.length < 6) {
      return 'New password must contain atleast 6 characters';
    } else if (_userTypedConfirmPassword != null &&
        _userTypedConfirmPassword.length > 0) {
      if (_userTypedConfirmPassword != newPasssword) {
        return 'New and Confirm password must be same';
      }
    }
    return null;
  }

  String _validateUserConfirmPassword(String confirmPasssword) {
    if (confirmPasssword.length == 0) {
      return 'Confirm password can\'t be empty';
    } else if (confirmPasssword.length > 0 && confirmPasssword.length < 6) {
      return 'Confirm password must contain atleast 6 characters';
    } else if (_userTypedNewPassword != null &&
        _userTypedNewPassword.length > 0) {
      if (_userTypedNewPassword != confirmPasssword) {
        return 'New and Confirm password must be same';
      }
    }
    return null;
  }


  validateSignUp() {
    if (_formKey.currentState.validate()) {
      callRegister();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  goToForgotPassword() {
    Get.to(() => ForgotPassword());
  }

  void callRegister() {
    CommonWidgets().showNetworkProcessingDialog();
    var resBody = {};
    resBody["name"] = _name.trim();
    resBody["email"] = _email.trim();
    resBody["phone"] = _phone.trim();
    resBody["password"] = _userTypedConfirmPassword.trim();
    _commonInfoBloc.registerUser(json.encode(resBody)).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        Fluttertoast.showToast(
            msg: response.message ??
                "Registered as sales manager");
        Get.offAll(() => LoginScreen());
      } else {
        Fluttertoast.showToast(
            msg: response.message ??
                "Something went wrong, please try again later");
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err.toString());
    });
  }
}
