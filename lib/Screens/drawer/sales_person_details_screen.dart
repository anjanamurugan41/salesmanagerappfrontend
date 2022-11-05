import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/SalesPersonDetailBloc.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Models/PersonalInfo.dart';
import 'package:sales_manager_app/Models/SalesPersonModel.dart';
import 'package:sales_manager_app/Screens/ViewAllTasksOfSalesPerson.dart';
import 'package:sales_manager_app/Screens/home/home_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'my_tasks_screen.dart';

class SalesPersonDetailsScreen extends StatefulWidget {
  int salesPersonId;
  var fromPage;

  SalesPersonDetailsScreen({Key key, this.salesPersonId, this.fromPage})
      : super(key: key);

  @override
  _SalesPersonDetailsScreenState createState() =>
      _SalesPersonDetailsScreenState();
}

class _SalesPersonDetailsScreenState extends State<SalesPersonDetailsScreen> {
  SalesPersonDetailBloc _salesPersonDetailBloc;
  bool isToRefreshInfo = false;

  @override
  void initState() {
    super.initState();
    _salesPersonDetailBloc = SalesPersonDetailBloc();
    _salesPersonDetailBloc.getSalesPersonInfo(widget?.salesPersonId);
  }

  @override
  void dispose() {
    _salesPersonDetailBloc.dispose();
    super.dispose();
  }

  void _backPressFunction() {
    print("clicked");
    if (isToRefreshInfo) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.back();
    }
  }

  void _errorWidgetFunction() {
    if (_salesPersonDetailBloc != null) {
      _salesPersonDetailBloc.getSalesPersonInfo(widget?.salesPersonId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: CommonAppBar(
            text: "",
            buttonHandler: _backPressFunction,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.green,
            onRefresh: () {
              return _salesPersonDetailBloc.getSalesPersonInfo(widget?.salesPersonId);
            },
            child: StreamBuilder<ApiResponse<SalesPersonModel>>(
              stream: _salesPersonDetailBloc.profileStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return CommonApiLoader();
                      break;
                    case Status.COMPLETED:
                      return _buildUserWidget(snapshot.data.data);
                      break;
                    case Status.ERROR:
                      return CommonApiErrorWidget(
                          snapshot.data.message, _errorWidgetFunction);
                      break;
                  }
                }

                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserWidget(SalesPersonModel salesPersonInfo) {
    if (salesPersonInfo != null) {
      return ListView(
        padding: EdgeInsets.all(12),
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Container(
                  height: 70,
                  width: 70,
                  child: CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 60,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: getImage(salesPersonInfo.personalInfo),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Center(
                        child: Image(
                          image: AssetImage(
                            'assets/images/ic_avatar.png',
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                width: 12,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${salesPersonInfo.personalInfo.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Sales Person',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black45),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(12, 8, 8, 8),
                  leading: Icon(
                    CupertinoIcons.phone,
                    color: Colors.black87,
                  ),
                  title: Text('${salesPersonInfo.personalInfo.phone}'),
                  trailing: AppButton.elevated(
                    text: 'Call',
                    onTap: () {
                      launch('tel://${salesPersonInfo.personalInfo.phone}');
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 8, 8),
                  leading: Icon(
                    CupertinoIcons.mail,
                    color: Colors.black87,
                  ),
                  title: Text('${salesPersonInfo.personalInfo.email}'),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(12, 8, 8, 8),
              leading: Icon(
                Icons.calendar_today,
                color: Colors.black87,
              ),
              title: Text('View All Tasks'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
            onTap: () {
              viewAllTasks();
            },
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: CommonApiResultsEmptyWidget("Something went wrong",
            textColorReceived: Colors.black),
      );
    }
  }

  getImage(PersonalInfo personalInfo) {
    String img = "";
    if (personalInfo.image != null) {
      if (personalInfo.image != "") {
        img = personalInfo.image;
      }
    }
    return img;
  }

  void viewAllTasks() async {
    bool isDataUpdated = await Get.to(
        () => ViewAllTasksOfSalesPerson(salesPersonId: widget.salesPersonId));

    if (isDataUpdated != null && mounted) {
      if (isDataUpdated) {
        isToRefreshInfo = true;
      }
    }
  }
}
