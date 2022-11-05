import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/CommonInfoBloc.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_icon.dart';
import 'package:sales_manager_app/widgets/app_text_box.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key key}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userTypedCurrentPassword;
  String _userTypedNewPassword;
  String _userTypedConfirmPassword;
  bool _obscureCurrentPasswordText = true;
  bool _obscureNewPasswordText = true;
  bool _obscureConfirmPasswordText = true;
  CommonInfoBloc commonInfoBloc;

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  void _toggleCurrentPassword() {
    setState(() {
      _obscureCurrentPasswordText = !_obscureCurrentPasswordText;
    });
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
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: Row(
            children: [
              Expanded(
                child: CommonAppBar(
                  text: "",
                  buttonHandler: _backPressFunction,
                ),
                flex: 1,
              ),
              AppButton.text(
                text: 'Save',
                onTap: validateForm,
              ),
            ],
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .01),
                      Container(
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      _buildInputSection()
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  _buildInputSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 6,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current Password',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Current Password",
                  maxLinesReceived: 1,
                  maxLengthReceived: 10,
                  isPassword: true,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  obscureText: _obscureCurrentPasswordText,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _toggleCurrentPassword();
                    },
                    icon: Icon(
                      _obscureCurrentPasswordText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (val) => _userTypedCurrentPassword = val,
                  validator: _validateCurrentPassword),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'New Password',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "New Password",
                  maxLinesReceived: 1,
                  maxLengthReceived: 10,
                  isPassword: true,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  obscureText: _obscureNewPasswordText,
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
                  onChanged: (val) => _userTypedNewPassword = val,
                  validator: _validateUserNewPassword),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Confirm Password',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Confirm Password",
                  maxLinesReceived: 1,
                  maxLengthReceived: 10,
                  isPassword: true,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
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
                  onChanged: (val) => _userTypedConfirmPassword = val,
                  validator: _validateUserConfirmPassword),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
          ],
        ),
      ),
    );
  }

  String _validateCurrentPassword(String password) {
    if (password.length == 0) {
      return 'Current password can\'t be empty';
    } else if (password.length > 0 && password.length < 6) {
      return 'Provide valid one in current password';
    } else if (_userTypedNewPassword != null &&
        _userTypedNewPassword.length > 0) {
      if (_userTypedNewPassword == password) {
        return 'Current and New password must not be same';
      }
    } else if (_userTypedConfirmPassword != null &&
        _userTypedConfirmPassword.length > 0) {
      if (_userTypedConfirmPassword == password) {
        return 'Current and Confirm password must not be same';
      }
    }
    return null;
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
    if (_formKey.currentState.validate()) {
      callApiToChangePassword();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void callApiToChangePassword() {
    var resBody = {};
    resBody["current_password"] = _userTypedCurrentPassword;
    resBody["password"] = _userTypedNewPassword;

    CommonWidgets().showNetworkProcessingDialog();
    commonInfoBloc.changePassword(json.encode(resBody)).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        Fluttertoast.showToast(
            msg: response.message ?? "Successfully changed your password");
        Get.back();
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
