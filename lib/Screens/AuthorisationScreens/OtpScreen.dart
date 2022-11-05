import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/OtpBloc.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/CustomLibraries/pin_code_fields.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Models/OtpResponse.dart';
import 'package:sales_manager_app/Models/forgot_pass_verify_otp_response.dart';
import 'package:sales_manager_app/Screens/AuthorisationScreens/ResetPasswordScreen.dart';

class OtpScreen extends StatefulWidget {
  int otpreceived;
  String emailReceived;

  OtpScreen(this.emailReceived, this.otpreceived);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String currentText = "";
  bool hasError = false;
  TextEditingController pinController = new TextEditingController();
  OtpBloc _otpBloc;

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    _otpBloc = OtpBloc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Verify OTP",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    "Enter the OTP received",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Color(colorCoderTextGrey),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                Padding(
                  child: Container(
                    alignment: FractionalOffset.center,
                    child: PinCodeTextField(
                      maxLength: 4,
                      wrapAlignment: WrapAlignment.spaceBetween,
                      keyboardType: TextInputType.number,
                      pinTextAnimatedSwitcherTransition:
                          ProvidedPinBoxTextAnimation.scalingTransition,
                      pinBoxDecoration:
                          ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      highlightAnimationBeginColor: Color(colorCoderGreyBg),
                      highlightAnimationEndColor: Color(colorCoderGreyBg),
                      hasTextBorderColor: Color(colorCoderBorderWhite),
                      pinBoxColor: Color(buttonBgColor),
                      highlightPinBoxColor: Color(buttonBgColor),
                      pinBoxBorderWidth: 1,
                      pinBoxHeight: 50,
                      pinBoxWidth: 50,
                      pinBoxOuterPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      pinBoxRadius: 10,
                      pinTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                      pinTextAnimatedSwitcherDuration:
                          Duration(milliseconds: 300),
                      onTextChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      controller: pinController,
                      onDone: (txt) => _verifyOtpFunction(),
                      defaultBorderColor: Color(colorCoderBorderWhite),
                      highlightColor: Color(colorCoderGreyBg),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  // error showing widget
                  child: Text(
                    hasError ? "*Please fill up all the cells properly" : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade300, fontSize: 12),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .01),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                      // error showing widget
                      child: Text("Didn't get any OTP  ",
                          textAlign: TextAlign.end,
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Color(colorCodeBlack),
                              fontWeight: FontWeight.w400)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        primary: Colors.transparent,
                        elevation: 0.0,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        side: BorderSide(
                          width: 2.0,
                          color: Colors.transparent,
                        ),
                      ),
                      onPressed: () => _resendOtp(),
                      child: Text(
                        "Resend",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(colorCodeBlack),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .01),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CommonButton(
                      buttonText: "Verify",
                      bgColorReceived: Color(buttonBgColor),
                      borderColorReceived: Color(buttonBgColor),
                      textColorReceived: Color(colorCodeWhite),
                      buttonHandler: () {
                        if (currentText.length != 4) {
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          setState(() {
                            hasError = false;
                          });

                          _verifyOtpFunction();
                        }
                      }),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .045),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOtpFunction() {
    var resBody = {};
    resBody["otp"] = currentText;
    CommonWidgets().showNetworkProcessingDialog();
    _otpBloc.verifyOtp(json.encode(resBody)).then((value) {
      Get.back();
      ForgotPassVerifyOtpResponse otpResponse = value;
      if (otpResponse.success) {
        Fluttertoast.showToast(
            msg: otpResponse.message ?? "OTP verified successfully");
        Get.to(
            () => ResetPasswordScreen(otpResponse.userId, otpResponse.token));
      } else {
        Fluttertoast.showToast(msg: otpResponse.message);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  void _resendOtp() {
    var resBody = {};
    resBody["email"] = widget.emailReceived;
    CommonWidgets().showNetworkProcessingDialog();
    _otpBloc.sendOtp(json.encode(resBody)).then((value) {
      Get.back();
      OtpResponse otpResponse = value;
      if (otpResponse.success) {
        Fluttertoast.showToast(msg: "${otpResponse?.otp}");
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
