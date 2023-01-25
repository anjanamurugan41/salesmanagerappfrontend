import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../Blocs/SalesPersonsBloc.dart';
import '../../../Constants/CustomColorCodes.dart';
import '../../../Constants/EnumValues.dart';
import '../../../CustomLibraries/CustomLoader/LinearLoader.dart';
import '../../../CustomLibraries/CustomLoader/RoundedLoader.dart';
import '../../../CustomLibraries/CustomLoader/dot_type.dart';
import '../../../Elements/CommonApiErrorWidget.dart';
import '../../../Elements/CommonApiLoader.dart';
import '../../../Elements/CommonApiResultsEmptyWidget.dart';
import '../../../Elements/CommonAppBar.dart';
import '../../../Elements/CommonButton.dart';
import '../../../Interfaces/LoadMoreListener.dart';

import '../../../Models/AllSalesPersonResponse.dart';
import '../../../ServiceManager/ApiResponse.dart';
import '../../../Utilities/LoginModel.dart';
import '../../../widgets/app_card.dart';
import '../sales_person_details_screen.dart';

class SalesPersonToPerson extends StatefulWidget {
  SalesPersonToPerson({Key key, this.isToSelectPerson, this.fromPage})
      : super(key: key);
  bool isToSelectPerson;
  var fromPage;
  @override
  State<SalesPersonToPerson> createState() => _SalesPersonToPersonState();
}

class _SalesPersonToPersonState extends State<SalesPersonToPerson>    with LoadMoreListener {
  bool isLoadingMore = false;
  SalesPersonsToPersonBloc _personsBloc;
  ScrollController _itemsController;
  int value;
  SalesPersonsToPersonBloc selectedPerson;
 // TaskOperationsBloc _taskOperationsBloc;

  @override
  void initState() {
    super.initState();
    _itemsController = ScrollController();
    _itemsController.addListener(_scrollListener);
    _personsBloc = SalesPersonsToPersonBloc(this);
    _personsBloc.getSalesPersonstoPersons(false);
   // _taskOperationsBloc = TaskOperationsBloc();
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
          _personsBloc.getSalesPersonstoPersons(true);
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
      _personsBloc.getSalesPersonstoPersons(false);
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
                // Visibility(
                //   visible: getAddButtonVisibility(),
                //   child: TextButton(
                //     style: TextButton.styleFrom(primary: Colors.black87),
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.add_circle,
                //           size: 25,
                //         ),
                //         SizedBox(
                //           width: 6,
                //         ),
                //         Text(
                //           'Add',
                //           style: TextStyle(fontSize: 13),
                //         ),
                //         SizedBox(
                //           width: 10,
                //         ),
                //       ],
                //     ),
                //     onPressed: () async {
                //       bool isListUpdated =
                //       await Get.to(() => AddSalesPersonScreen());
                //       if (isListUpdated != null) {
                //         if (isListUpdated) {
                //           return _personsBloc.getSalesPersons(false);
                //         }
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.cyan,
            onRefresh: () {
              return _personsBloc.getSalesPersonstoPersons(false);
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
                        StreamBuilder<ApiResponse<SalesPersonToPersonModel>>(
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

  Widget _buildUserWidget(List<Data> membersList) {
    if (membersList != null) {
      if (membersList.length > 0) {
        return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 70),
            itemCount: membersList.length,
            controller: _itemsController,
            itemBuilder: (context, index) {
         return AppCard(onTap: (){
           Get.to(() =>  SalesPersonDetailsScreen(
             salesPersonId: membersList[index].id,
             fromPage: FromPage.SalesPersonsList,
           ));
         },
           child: Container(
             color: Colors.transparent,
             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
             padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
             child: ListTile(


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
                               imageUrl: membersList[index].image,
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
                                 "${membersList[index].name}",
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




  void assignSalesPerson() {
    if (selectedPerson != null) {
      Map<String, dynamic> data = Map();
      data.assign('selectedPersonInfo', selectedPerson);
      Get.back(result: data);
    } else {
      Fluttertoast.showToast(msg: "Please select a sales person to continue");
    }
  }

  getImage(SalesPersonInfo item) {
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

