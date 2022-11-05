import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/OtpBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/OtpResponse.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/OtpScreen.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

void _backPressFunction() {
  print("clicked");
  Get.back();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email;
  OtpBloc _otpBloc;

  @override
  void initState() {
    super.initState();
    _otpBloc = OtpBloc();
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
              text: "Forgot Password",
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
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .03),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              alignment: FractionalOffset.centerLeft,
                              child: Text(
                                "Enter the email associated with your account..",
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
                                  hintText: "Email",
                                  maxLinesReceived: 1,
                                  maxLengthReceived: 60,
                                  isEmail: true,
                                  textColorReceived: Color(colorCodeBlack),
                                  fillColorReceived: Color(colorCodeWhite),
                                  hintColorReceived: Color(colorCoderTextGrey),
                                  borderColorReceived: Color(colorCodeBlack),
                                  onChanged: (val) => email = val,
                                  validator: CommonMethods().emailValidator),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 15),
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

  validateForm() {
    if (formKey.currentState.validate()) {
      callSendOtp();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void callSendOtp() {
    var resBody = {};
    resBody["email"] = email.trim();
    CommonWidgets().showNetworkProcessingDialog();
    _otpBloc.sendOtp(json.encode(resBody)).then((value) {
      Get.back();
      OtpResponse otpResponse = value;
      if (otpResponse.success) {
        Fluttertoast.showToast(msg: "${otpResponse?.otp}");
        Get.to(() => OtpScreen(email.trim(), otpResponse?.otp));
      } else {
        Fluttertoast.showToast(
            msg: otpResponse.message ?? "Something went wrong");
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }
}
