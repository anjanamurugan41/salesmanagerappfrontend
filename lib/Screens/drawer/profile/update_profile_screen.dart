import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:sales_manager_app/Blocs/CommonInfoBloc.dart';
import 'package:sales_manager_app/Constants/CommonMethods.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/StringConstants.dart';
import 'package:sales_manager_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:sales_manager_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:sales_manager_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonTextFormField.dart';
import 'package:sales_manager_app/Models/ProfileResponse.dart';
import 'package:sales_manager_app/Models/UserDetails.dart';
import 'package:sales_manager_app/widgets/app_button.dart';

class UpdateProfileScreen extends StatefulWidget {
  UserDetails userDetails;

  UpdateProfileScreen(this.userDetails);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _phone;
  String _email;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  CommonInfoBloc _commonInfoBloc;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    initValues();
    _commonInfoBloc = CommonInfoBloc();
  }

  void initValues() {
    if (widget.userDetails != null) {
      _nameController.text = widget.userDetails.name;
      _name = widget.userDetails.name;

      _emailController.text = widget.userDetails.email;
      _email = widget.userDetails.email;

      _phoneController.text = widget.userDetails.phone;
      _phone = widget.userDetails.phone;
    }
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
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
                  text: 'Update',
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
                            'Edit Profile',
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
          )),
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
            _buildImageSection(),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            Text(
              'Full Name',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
            ),
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
                  controller: _nameController,
                  validator: CommonMethods().requiredValidator),
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
                  controller: _phoneController,
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
                  controller: _emailController,
                  onChanged: (val) => _email = val,
                  validator: CommonMethods().emailValidator),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
          ],
        ),
      ),
    );
  }

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._image = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
  }

  _buildImageSection() {
    return Container(
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 190,
      color: Colors.transparent,
      child: Container(
        height: 160.0,
        width: 160.0,
        child: Stack(children: <Widget>[
          Align(
            alignment: FractionalOffset.center,
            child: Container(
              width: 150,
              height: 150,
              decoration: new BoxDecoration(
                color: Colors.black26,
                borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
                border: new Border.all(
                  color: Colors.blue,
                  width: 6.0,
                ),
              ),
              child: ClipOval(
                child: SizedBox.expand(
                  child: showImage(),
                ),
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: Container(
                child: InkWell(
                  child: Image.asset(
                    ('assets/images/ic_camera.png'),
                    height: 45,
                    width: 45,
                  ),
                  onTap: () {
                    imagePicker.showDialog(context);
                  },
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget showImage() {
    return Center(
      child: _image == null
          ? CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: "${widget.userDetails.image}",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => TextDrawableWidget(
                CommonMethods().titleCase("ss"),
                ColorGenerator.materialColors,
                (bool selected) {
                  // on tap callback
                  print("on tap callback");
                },
                false,
                140.0,
                140.0,
                BoxShape.circle,
                TextStyle(color: Colors.white, fontSize: 40.0),
              ),
            )
          : Container(
              height: 140.0,
              width: 140.0,
              child: SizedBox.expand(
                child: Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(const Radius.circular(70.0)),
              ),
            ),
    );
  }

  validateSave() {
    if (_formKey.currentState.validate()) {
      callUpdate();
    } else {
      Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
      return;
    }
  }

  void callUpdate() async {
    Map<String, dynamic> body = {
      'image': getImageToPass(),
      'name': _name.trim(),
      'email': _email.trim(),
      'phone': _phone.trim()
    };
    dio.FormData formData = dio.FormData.fromMap(body);

    CommonWidgets().showNetworkProcessingDialog();
    _commonInfoBloc.updateProfile(formData).then((value) {
      Get.back();
      ProfileResponse response = value;
      if (response.success) {
        Fluttertoast.showToast(msg: response.message);
        Get.back(result: true);
      } else {
        Fluttertoast.showToast(
            msg: response.message ?? StringConstants.apiFailureMsg);
      }
    }).catchError((err) {
      Get.back();
      CommonWidgets().showNetworkErrorDialog(err?.toString());
    });
  }

  getImageToPass() {
    if (_image != null) {
      String fileName = _image.path.split('/').last;
      String mimeType = mime(fileName);
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      return dio.MultipartFile.fromFileSync(_image.path,
          filename: fileName, contentType: MediaType(mimee, type));
    }

    return null;
  }
}
