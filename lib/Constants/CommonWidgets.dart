import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';

import '../CustomLibraries/CustomLoader/RoundedLoader.dart';
import '../Utilities///LoginModel.dart';
import 'CommonMethods.dart';
import 'CustomColorCodes.dart';
import 'StringConstants.dart';

class CommonWidgets {
  showNetworkProcessingDialog() {
    return Get.dialog(WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0, bottom: 15.0),
                child: Text(
                  "Please wait",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
              RoundedLoader(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        )));
  }

  showNetworkErrorDialog(msg) {
    CommonMethods().isInternetAvailable().then((onValue) {
      if (onValue) {
        showErrorDialog(msg);
      } else {
        showNetworkFailureDialog();
      }
    });
  }

  void showErrorDialog(msg) {
    Get.defaultDialog(
        onWillPop: () async => false,
        backgroundColor: Colors.white,
        barrierDismissible: false,
        radius: 15,
        title: "",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white30),
                    onPressed: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Close",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ));
  }

  void showNetworkFailureDialog() {
    Get.defaultDialog(
        onWillPop: () async => false,
        backgroundColor: Colors.white,
        barrierDismissible: false,
        radius: 15,
        title: "",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/ic_404_error.png'),
              height: Get.size.height * .30,
              width: Get.size.width * .50,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                10,
                0,
                10,
                10,
              ),
              child: Text(
                "Could not connect to Internet",
                style: new TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                10,
                0,
                10,
                0,
              ),
              child: Text(
                "Please check your network settings",
                style: new TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white30),
              onPressed: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Close",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0),
                ),
              ),
            )
          ],
        ));
  }

  Widget getErrorInfo(BuildContext context, String message, Color textColor) {
    if (LoginModel().isNetworkAvailable) {
      return Container(
        alignment: FractionalOffset.center,
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    } else {
      return Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/no_internet.png'),
                height: MediaQuery.of(context).size.height * .30,
                width: MediaQuery.of(context).size.width * .50,
              ),
              Container(
                alignment: FractionalOffset.center,
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  "${StringConstants.netFailureMsg}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          )
        ],
      );
    }
  }

  showCommonDialog(String msg, var assetImage, Function _buttonHandler,
      bool isBarrierDismissible, bool isToShowCloseButton) {
    return Get.dialog(
        WillPopScope(
            onWillPop: () async => isBarrierDismissible,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Image(
                    image: assetImage,
                    height: 120.0,
                    width: 160.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 13.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: CommonButton(
                        buttonText: "Ok",
                        bgColorReceived: Color(colorCodeSplashGradient1),
                        borderColorReceived: Color(colorCodeSplashGradient1),
                        textColorReceived: Color(colorCodeWhite),
                        buttonHandler: _buttonHandler),
                  ),
                  Visibility(
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: CommonButton(
                          buttonText: "Cancel",
                          bgColorReceived: Color(colorCodeWhite),
                          borderColorReceived: Color(colorCodeSplashGradient1),
                          textColorReceived: Color(colorCodeSplashGradient1),
                          buttonHandler: () {
                            Get.back();
                          }),
                    ),
                    visible: isToShowCloseButton,
                  ),
                ],
              ),
            )),
        barrierDismissible: isBarrierDismissible);
  }
}
