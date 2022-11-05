import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/CommonInfoBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/forgot_pass_update_pass_response.dart';

import 'LoginScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  int accountIdReceived;
  String tempTokenReceived;

  ResetPasswordScreen(this.accountIdReceived, this.tempTokenReceived);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _userTypedNewPassword;
  String _userTypedConfirmPassword;
  bool _obscureNewPasswordText = true;
  bool _obscureConfirmPasswordText = true;
  CommonInfoBloc commonInfoBloc;

  void _backPressFunction() {
    print("clicked");
    Get.back();
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
  void initState() {
    super.initState();
    commonInfoBloc = new CommonInfoBloc();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Get.back();
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(colorCodeWhite),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Change Password",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset.center,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(_blankFocusNode);
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: FractionalOffset.centerLeft,
                                child: Text(
                                  "Create a new password..",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(colorCodeBlack),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .03),
                              Padding(
                                child: CommonTextFormField(
                                    hintText: "New Password",
                                    maxLinesReceived: 1,
                                    maxLengthReceived: 8,
                                    isPassword: true,
                                    textColorReceived: Color(colorCodeBlack),
                                    fillColorReceived: Color(colorCodeWhite),
                                    hintColorReceived:
                                        Color(colorCoderTextGrey),
                                    borderColorReceived: Color(colorCodeBlack),
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
                                    textColorReceived: Color(colorCodeBlack),
                                    fillColorReceived: Color(colorCodeWhite),
                                    hintColorReceived:
                                        Color(colorCoderTextGrey),
                                    borderColorReceived: Color(colorCodeBlack),
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
                                  height:
                                      MediaQuery.of(context).size.height * .01),
                            ],
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 5, 30, 15),
                      child: CommonButton(
                          buttonText: "Submit",
                          bgColorReceived: Color(buttonBgColor),
                          borderColorReceived: Color(buttonBgColor),
                          textColorReceived: Color(colorCodeWhite),
                          buttonHandler: validateForm),
                    ),
                  ],
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

  validateForm() {
    if (formKey.currentState.validate()) {
      print("forgot api call");
      print("***");
      callApiToResetPassword();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void callApiToResetPassword() {
    var resBody = {};
    resBody["userid"] = widget.accountIdReceived;
    resBody["password_reset_token"] = widget.tempTokenReceived;
    resBody["newpassword"] = _userTypedNewPassword;
    resBody["cpassword"] = _userTypedConfirmPassword;

    CommonWidgets().showNetworkProcessingDialog();
    commonInfoBloc.resetPassword(json.encode(resBody)).then((value) {
      Get.back();
      ForgotPassUpdatePassResponse response = value;
      if (response.success) {
        CommonMethods().clearData();
        Get.offAll(LoginScreen());
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? "Unable to process your request");
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
