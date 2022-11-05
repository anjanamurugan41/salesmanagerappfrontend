import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/CommonInfoBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/widgets/app_button.dart';

class AddSalesPersonScreen extends StatefulWidget {
  const AddSalesPersonScreen({Key key}) : super(key: key);

  @override
  _AddSalesPersonScreenState createState() => _AddSalesPersonScreenState();
}

class _AddSalesPersonScreenState extends State<AddSalesPersonScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _phone;
  String _userTypedNewPassword;
  bool _obscureNewPasswordText = true;
  CommonInfoBloc _commonInfoBloc;

  void _toggleNewPassword() {
    setState(() {
      _obscureNewPasswordText = !_obscureNewPasswordText;
    });
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    _commonInfoBloc = CommonInfoBloc();
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
                onTap: validateSave,
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
                          'Add Sales Person',
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
            Padding(
              child: CommonTextFormField(
                  hintText: "Name",
                  maxLinesReceived: 1,
                  maxLengthReceived: 60,
                  isEmail: false,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _name = val,
                  validator: CommonMethods().nameValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Phone Number',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Phone",
                  maxLinesReceived: 1,
                  maxLengthReceived: 15,
                  isDigitsOnly: true,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _phone = val,
                  validator: CommonMethods().validateMobile),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Email',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Email",
                  maxLinesReceived: 1,
                  maxLengthReceived: 60,
                  isEmail: true,
                  textColorReceived: Colors.black,
                  fillColorReceived: Colors.transparent,
                  hintColorReceived: Colors.black45,
                  borderColorReceived: Colors.black45,
                  onChanged: (val) => _email = val,
                  validator: CommonMethods().emailValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Password',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
            Padding(
              child: CommonTextFormField(
                  hintText: "Password",
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
            SizedBox(height: MediaQuery.of(context).size.height * .02),
          ],
        ),
      ),
    );
  }

  validateSave() {
    if (_formKey.currentState.validate()) {
      callAddSalesMan();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  String _validateUserNewPassword(String newPasssword) {
    if (newPasssword.length == 0) {
      return 'New password can\'t be empty';
    } else if (newPasssword.length > 0 && newPasssword.length < 6) {
      return 'New password must contain atleast 6 characters';
    }
    return null;
  }

  void callAddSalesMan() {
    CommonWidgets().showNetworkProcessingDialog();
    var resBody = {};
    resBody["name"] = _name.trim();
    resBody["email"] = _email.trim();
    resBody["phone"] = _phone.trim();
    resBody["password"] = _userTypedNewPassword.trim();
    _commonInfoBloc.createSalesPerson(json.encode(resBody)).then((value) {
      Get.back();
      CommonSuccessResponse response = value;
      if (response.success) {
        Fluttertoast.showToast(msg: response.message);
        Get.back(result: true);
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
