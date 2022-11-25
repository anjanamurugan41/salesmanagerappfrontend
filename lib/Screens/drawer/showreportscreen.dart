import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/widgets/app_icon.dart';
import 'package:url_launcher/url_launcher.dart';

enum Share { whatsapp }

class ShowReportScreen extends StatefulWidget {
  const ShowReportScreen({Key key}) : super(key: key);

  @override
  State<ShowReportScreen> createState() => _ShowReportScreenState();
}

class _ShowReportScreenState extends State<ShowReportScreen> {
  String mail = "info@crowdworksindia.org";

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child:Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    _backPressFunction();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
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
                SizedBox(width: 10,),
                Expanded(
                    child: Text("Report",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )),
                AppIcon(
                    iconData: CupertinoIcons.down_arrow,
                    onTap: () {

                    }),
              ],
            ),
          )),
          // CommonAppBar(
          //   text: "Report",
          //   buttonHandler: _backPressFunction,
          // ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: FractionalOffset.topCenter,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("You can download and share your reports",style: TextStyle(
                  fontWeight: FontWeight.w500
                ),),
                SizedBox(height: 15,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.66,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      width: 2,
                      color: Color(buttonBgColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.share),
          backgroundColor: Color(buttonBgColor),
          onPressed: () {
            share();
          },
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Sales App',
      text: "inviting to use Sales App ,Most useful and helping App. ",
      // chooserTitle: 'Sales app'
    );
  }
}
