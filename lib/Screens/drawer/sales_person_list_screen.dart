import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/SalesPersonsBloc.dart';
import 'package:sales_manager_app/Blocs/TaskOperationsBloc.dart';
import 'package:sales_manager_app/Constants/CommonWidgets.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/LinearLoader.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/dot_type.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Interfaces/LoadMoreListener.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/CommonSuccessResponse.dart';
import 'package:sales_manager_app/Screens/drawer/add_sales_person_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/widgets/app_card.dart';
import 'package:sales_manager_app/widgets/app_icon.dart';

import 'sales_person_details_screen.dart';

class SalesPersonListScreen extends StatefulWidget {
  SalesPersonListScreen({Key key, this.isToSelectPerson, this.fromPage})
      : super(key: key);
  bool isToSelectPerson;
  var fromPage;

  @override
  _SalesPersonListScreenState createState() => _SalesPersonListScreenState();
}

class _SalesPersonListScreenState extends State<SalesPersonListScreen>
    with LoadMoreListener {
  bool isLoadingMore = false;
  SalesPersonsBloc _personsBloc;
  ScrollController _itemsController;
  int value;
  Data1 selectedPerson;
  TaskOperationsBloc _taskOperationsBloc;

  @override
  void initState() {
    super.initState();
    _itemsController = ScrollController();
    _itemsController.addListener(_scrollListener);
    _personsBloc = SalesPersonsBloc(this);
    _personsBloc.getSalesPersons(false);
    _taskOperationsBloc = TaskOperationsBloc();
  }

  @override
  void dispose() {
    _itemsController.dispose();
    _personsBloc.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_itemsController.offset >= _itemsController.position.maxScrollExtent &&
        !_itemsController.position.outOfRange) {
      print("reach the bottom");
      if (_personsBloc.hasNextPage) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _personsBloc.getSalesPersons(true);
        });
      }
    }
    if (_itemsController.offset <= _itemsController.position.minScrollExtent &&
        !_itemsController.position.outOfRange) {
      print("reach the top");
    }
  }

  void _errorWidgetFunction() {
    if (_personsBloc != null) {
      _personsBloc.getSalesPersons(false);
    }
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // here the desired height
            child: Row(
              children: [
                Expanded(
                  child: CommonAppBar(
                    text: widget.isToSelectPerson
                        ? "Select anyone"
                        : "Sales Persons",
                    buttonHandler: _backPressFunction,
                  ),
                  flex: 1,
                ),
                Visibility(
                  visible: getAddButtonVisibility(),
                  child: TextButton(
                    style: TextButton.styleFrom(primary: Colors.black87),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          size: 25,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Add',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      bool isListUpdated =
                          await Get.to(() => AddSalesPersonScreen());
                      if (isListUpdated != null) {
                        if (isListUpdated) {
                          return _personsBloc.getSalesPersons(false);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.cyan,
            onRefresh: () {
              return _personsBloc.getSalesPersons(false);
            },
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: FractionalOffset.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                            StreamBuilder<ApiResponse<AllSalesPersonResponse>>(
                                stream: _personsBloc.memberListStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data.status) {
                                      case Status.LOADING:
                                        return CommonApiLoader();
                                        break;
                                      case Status.COMPLETED:
                                        return _buildUserWidget(
                                            _personsBloc.memberItemsList);
                                        break;
                                      case Status.ERROR:
                                        return CommonApiErrorWidget(
                                            snapshot.data.message,
                                            _errorWidgetFunction);
                                        break;
                                    }
                                  }
                                  return Container(
                                    child: Center(
                                      child: Text(""),
                                    ),
                                  );
                                }),
                        flex: 1,
                      ),
                      Visibility(
                        child: Opacity(
                          opacity: 1.0,
                          child: Container(
                            color: Colors.transparent,
                            alignment: FractionalOffset.center,
                            height: 50,
                            child: LinearLoader(
                              dotOneColor: Colors.red,
                              dotTwoColor: Colors.orange,
                              dotThreeColor: Colors.green,
                              dotType: DotType.circle,
                              dotIcon: Icon(Icons.adjust),
                              duration: Duration(seconds: 1),
                            ),
                          ),
                        ),
                        visible: isLoadingMore ? true : false,
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: widget.isToSelectPerson && getVisibility(),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: CommonButton(
                            buttonText: " Select ",
                            bgColorReceived: Color(buttonBgColor),
                            borderColorReceived: Color(buttonBgColor),
                            textColorReceived: Color(colorCodeWhite),
                            buttonHandler: () {
                              if (_personsBloc.memberItemsList != null &&
                                  _personsBloc.memberItemsList.length > 0) {
                                assignSalesPerson();
                                print("Have contents");
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please try again later");
                              }
                            }),
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  bool getVisibility() {
    if (_personsBloc != null) {
      if (_personsBloc.memberItemsList != null &&
          _personsBloc.memberItemsList.length > 0) {
        if (!isLoadingMore) {
          return true;
        }
      }
    }
    return false;
  }

  Widget _buildUserWidget(List<Data1> membersList) {
    if (membersList != null) {
      if (membersList.length > 0) {
        return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 70),
            itemCount: membersList.length,
            controller: _itemsController,
            itemBuilder: (context, index) {
              if (widget.isToSelectPerson) {
                return _buildSalesPersonToSelect(index, membersList[index]);
              } else {
                return _buildSalesPersonInfo(membersList[index]);
              }
            });
      } else {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: CommonApiResultsEmptyWidget("Results Empty",
              textColorReceived: Colors.black),
        );
      }
    } else {
      return CommonApiErrorWidget("No results found", _errorWidgetFunction,
          textColorReceived: Colors.black);
    }
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }

  Widget _buildSalesPersonInfo(Data1 salesPersonInfo) {
    return AppCard(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black12.withOpacity(0.05),
                child: ClipOval(
                  child: SizedBox.expand(
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: getImage(salesPersonInfo),
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: RoundedLoader(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        child: Image(
                          image: AssetImage('assets/images/no_image.png'),
                        ),
                        margin: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.fromLTRB(15, 2, 10, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // add this
                  children: <Widget>[
                    Container(
                      alignment: FractionalOffset.centerLeft,
                      padding: EdgeInsets.only(top: 0, left: 0),
                      child: Text(
                        "${salesPersonInfo.name}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Color(colorCodeLightDarkGrey),
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            salesPersonInfo.isActive == 1 ?
           Text("Active",style: TextStyle(color:Color(buttonBgColor),fontSize: 13 ,
               fontWeight: FontWeight.w500),):
            Text("Inactive",style: TextStyle(color:Colors.red,fontSize: 13 ,
                fontWeight: FontWeight.w500),),
            // IconButton(onPressed: (){
            //
            // }, icon: Icon(Icons.delete_outline,color: Colors.red[400],))
          ],
        ),
      ),
      onTap: () {
        Get.to(() => SalesPersonDetailsScreen(
              salesPersonId: salesPersonInfo.id,
              fromPage: FromPage.SalesPersonsList,
            ));
      },
    );
  }

  Widget _buildSalesPersonToSelect(int index, Data1 salesPersonInfo) {
    return AppCard(
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: RadioListTile(
            activeColor: Colors.cyan,
            value: index,
            groupValue: value,
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (ind) {
              setState(() {
                value = ind;
              });
              selectedPerson = salesPersonInfo;
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black12.withOpacity(0.05),
                    child: ClipOval(
                      child: SizedBox.expand(
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: getImage(salesPersonInfo),
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: RoundedLoader(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            child: Image(
                              image: AssetImage('assets/images/no_image.png'),
                            ),
                            margin: EdgeInsets.all(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.fromLTRB(15, 2, 10, 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // add this
                      children: <Widget>[
                        Container(
                          alignment: FractionalOffset.centerLeft,
                          padding: EdgeInsets.only(top: 0, left: 0),
                          child: Text(
                            "${salesPersonInfo.name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Color(colorCodeLightDarkGrey),
                                fontSize: 14.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
              ],
            )),
      ),
    );
  }

  void assignSalesPerson() {
    if (selectedPerson != null) {
      Map<String, dynamic> data = Map();
      data.assign('selectedPersonInfo', selectedPerson);
      Get.back(result: data);
    } else {
      Fluttertoast.showToast(msg: "Please select a sales person to continue");
    }
  }

  getImage(Data1 item) {
    String img = "";
    if (item.image != null) {
      if (item.image != "") {
        img = item.image;
      }
    }
    return img;
  }

  getAddButtonVisibility() {
    if (LoginModel().userDetails.role == "admin") {
      if (widget.fromPage == FromPage.ReportFilterPage ||
          widget.fromPage == FromPage.CalenderPage) {
        return false;
      }
    } else {
      return false;
    }

    return true;
  }
}
