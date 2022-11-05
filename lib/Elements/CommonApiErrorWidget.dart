import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';


class CommonApiErrorWidget extends StatelessWidget {
  final String text;
  final Function buttonHandler;
  final Color textColorReceived;

  CommonApiErrorWidget(this.text, this.buttonHandler,
      {this.textColorReceived = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CommonWidgets().getErrorInfo(context, text, textColorReceived),
        SizedBox(height: 8),
        MaterialButton(
          height: 40,
          color: Color(buttonBgColor),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
          onPressed: buttonHandler,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              30,
              0,
              30,
              0,
            ),
            child: Text(
              "Retry",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
