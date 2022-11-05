import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String buttonText;
  final Function buttonHandler;
  final Color textColorReceived;
  final Color bgColorReceived;
  final Color borderColorReceived;

  CommonButton(
      {this.buttonText,
      this.textColorReceived,
      this.bgColorReceived,
      this.borderColorReceived,
      this.buttonHandler});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        primary: bgColorReceived,
        elevation: 0.0,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        side: BorderSide(
          width: 0.5,
          color: borderColorReceived,
        ),
      ),
      onPressed: () {
        buttonHandler();
      },
      child: Text(
        "$buttonText",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColorReceived,
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
