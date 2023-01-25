import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';

import '../Utilities/LoginModel.dart';

class NotificationListItem extends StatelessWidget {
  final VoidCallback onTap;
  final names;
  final title;
  String time;
  String type;

  int id;

  NotificationListItem(
      {Key key,

        @required this.onTap,
        @required this.names,
        this.title,
        this.time,
this.type,
        this.id})


      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginModel().userDetails.role=="salesman" ?Container(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(buttonBgColor),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        color: Colors.grey[200],
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),

            SizedBox(width: MediaQuery.of(context).size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  "$names Assigned You",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  "${title} ${type}" ,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  "Task time : $time",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            // Spacer(),
            // IconButton(onPressed: (){
            // }, icon: Icon(Icons.close)),
          ],
        ),
      ),
    ):Container(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(buttonBgColor),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        color: Colors.grey[200],
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),

            SizedBox(width: MediaQuery.of(context).size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  "${names} ${type}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  "Task time : $time",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            // Spacer(),
            // IconButton(onPressed: (){
            // }, icon: Icon(Icons.close)),
          ],
        ),
      ),
    );
  }

}

