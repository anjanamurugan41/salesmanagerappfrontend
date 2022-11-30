import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart' as shr;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Utilities/app_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowReportScreen extends StatefulWidget {
  final File pdf;
  const ShowReportScreen({Key key, this.pdf}) : super(key: key);

  @override
  State<ShowReportScreen> createState() => _ShowReportScreenState();
}

class _ShowReportScreenState extends State<ShowReportScreen> {
  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pdf.path);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CommonAppBar(
                text: "Report",
                buttonHandler: _backPressFunction,
              ),
            )),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: FractionalOffset.topCenter,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "You can share your report",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.58,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Color(buttonBgColor),
                    ),
                  ),
                  child: SfPdfViewer.file(
                    widget.pdf,
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
            //shareFile();
          },
        ),
      ),
    );
  }

  Future<void> share() async {
    await Share.shareFiles(
      [widget.pdf.path],
    );
  }

  Future<void> shareFile() async {
    await shr.FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: widget.pdf.path,
    );
  }

  // Future<void> shareFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result == null || result.files.isEmpty) return null;
  //
  //   await FlutterShare.shareFile(
  //     title: 'Example share',
  //     text: 'Example share text',
  //     filePath: result.files[0] as String,
  //   );
  // }

}
