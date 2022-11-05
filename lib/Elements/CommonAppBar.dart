import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';

class CommonAppBar extends StatelessWidget {
  final String text;
  final Function buttonHandler;

  CommonAppBar({this.text, this.buttonHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.transparent,
      alignment: FractionalOffset.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: buttonHandler,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: Color(buttonBgColor),
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: Color(buttonBgColor),
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                alignment: FractionalOffset.centerLeft,
                child: Text("$text",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600))),
            flex: 1,
          )
        ],
      ),
    );
  }
}
