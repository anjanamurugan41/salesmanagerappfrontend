import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/SearchBloc.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiResultsEmptyWidget.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Models/SearchResponse.dart';
import 'package:sales_manager_app/Screens/drawer/sales_person_details_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';

import '../task_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isApiCallInProgress = false;
  FocusNode _searchFocus = FocusNode();
  var typedVal = "";
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = new SearchBloc();
    _searchBloc.getSearchItems("");
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchBloc.dispose();
    super.dispose();
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  void _errorWidgetFunction() {
    if (_searchBloc != null) {
      if (searchController.text.isNotEmpty) {
        _searchBloc.getSearchItems(searchController.text.trim());
      }
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
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildSearchSection(),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  onRefresh: () {
                    return _searchBloc
                        .getSearchItems(searchController.text.trim());
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: StreamBuilder<ApiResponse<SearchResponse>>(
                        stream: _searchBloc.searchStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return CommonApiLoader();
                                break;
                              case Status.COMPLETED:
                                SearchResponse res = snapshot.data.data;
                                return _buildUserWidget(res.searchList);
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
                  ),
                ),
                flex: 1,
              ),
            ],
          )),
    );
  }

  _buildSearchSection() {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: TextField(
          controller: searchController,
          maxLines: 1,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            _searchFocus.unfocus();
            if (searchController.text.isNotEmpty &&
                typedVal != searchController.text.trim()) {
              searchKeyword();
            }
          },
          onChanged: (value) {
            print("****");
            if (typedVal != value.trim()) {
              if (value.length > 2 || value.length == 0) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  if (_searchBloc != null) {
                    typedVal = value.trim();
                    _searchBloc.getSearchItems(value.trim());
                  }
                });
              }
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 14),
            prefixIcon: Icon(CupertinoIcons.search),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  searchController.text = "";
                });
              },
              icon: Icon(CupertinoIcons.clear),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          ),
        ));
  }

  _buildUserWidget(List<SearchItem> _searchList) {
    if (_searchList != null) {
      if (_searchList.length > 0) {
        return ListView.separated(
          itemCount: _searchList.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            return _buildEachSearchItem(_searchList[index]);
          },
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(2, 15, 5, 20),
        );
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
          textColorReceived: Colors.white);
    }
  }

  _buildEachSearchItem(SearchItem searchItem) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.refresh,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Padding(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text("${searchItem.title}",
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(colorCoderItemTitle),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600)),
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        child: Text("${searchItem.type}",
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(colorCoderItemSubTitle),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500)),
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                ),
                flex: 1,
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        if (searchItem.type == "task") {
          Get.to(() => TaskDetailsScreen(taskId: searchItem.id));
        } else {
          Get.to(() => SalesPersonDetailsScreen(
                salesPersonId: searchItem.id,
              ));
        }
      },
    );
  }

  void searchKeyword() {
    print("${searchController.text}");
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_searchBloc != null) {
        typedVal = searchController.text.trim();
        _searchBloc.getSearchItems(searchController.text.trim());
      }
    });
  }
}
