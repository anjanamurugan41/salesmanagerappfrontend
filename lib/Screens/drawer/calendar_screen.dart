import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sales_manager_app/Blocs/MonthWiseReportBloc.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Constants/EnumValues.dart';
import 'package:sales_manager_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:sales_manager_app/Elements/CommonApiErrorWidget.dart';
import 'package:sales_manager_app/Elements/CommonApiLoader.dart';
import 'package:sales_manager_app/Elements/CommonAppBar.dart';
import 'package:sales_manager_app/Elements/CommonButton.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Models/AllTaskResponse.dart';
import 'package:sales_manager_app/Screens/drawer/sales_person_list_screen.dart';
import 'package:sales_manager_app/ServiceManager/ApiResponse.dart';
import 'package:sales_manager_app/Utilities/LoginModel.dart';
import 'package:sales_manager_app/widgets/app_button.dart';
import 'package:sales_manager_app/widgets/app_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _month = 'January';
  int _year = 2021;
  int _yearToFilter = 2021;
  String _monthToFilter = 'January';

  List<String> _monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<int> _yearList = [];
  Data1 salesPersonReceived;
  MonthWiseReportBloc _monthWiseReportBloc;

  DateTime _currentDate;

  static Widget _presentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    super.initState();
    _monthWiseReportBloc = MonthWiseReportBloc();
    _year = DateTime.now().year;
    _month = _monthList[DateTime.now().month - 1];
    _yearList = List<int>.generate(50, (i) => _year - i);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Calendar",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: CustomScrollView(slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10, 70),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AppCard(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Filter',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _month,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items: _monthList.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              _month = val;
                                            });
                                          },
                                        ),
                                      )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                          child: DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: _year,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items: _yearList.map((int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text('$value'),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              _year = val;
                                            });
                                          },
                                        ),
                                      )),
                                    ],
                                  ),
                                  Divider(),
                                  Visibility(
                                    child: Text(
                                      'Sales Person',
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    visible:
                                        LoginModel().userDetails.role == "admin"
                                            ? true
                                            : false,
                                  ),
                                  _buildAddSalesPerson(),
                                  Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: CommonButton(
                                        buttonText: " Show ",
                                        bgColorReceived: Color(buttonBgColor),
                                        borderColorReceived:
                                            Color(buttonBgColor),
                                        textColorReceived:
                                            Color(colorCodeWhite),
                                        buttonHandler: applyFilter),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: StreamBuilder<ApiResponse<AllTaskResponse>>(
                                stream: _monthWiseReportBloc.tasksStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data.status) {
                                      case Status.LOADING:
                                        return Container(
                                          height: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                        break;
                                      case Status.COMPLETED:
                                        AllTaskResponse response =
                                            snapshot.data.data;
                                        return _buildUserWidget();
                                        break;
                                      case Status.ERROR:
                                        return Container(
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                                "${snapshot.data.message}"),
                                          ),
                                        );
                                        break;
                                    }
                                  }
                                  return Container(
                                    child: Center(
                                      child: Text(""),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ]),
                  ),
                )
              ]))),
    );
  }

  _buildAddSalesPerson() {
    if (LoginModel().userDetails.role == "admin") {
      if (salesPersonReceived != null) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
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
              radius: 25,
              backgroundColor: Colors.black12.withOpacity(0.05),
              child: ClipOval(
                child: SizedBox.expand(
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: getImage(),
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
          title: Text(
            "${salesPersonReceived.name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: Color(colorCodeBlack),
                fontSize: 14.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600),
          ),
          trailing: AppButton.elevated(
            text: salesPersonReceived != null ? "Change" : "Add",
            onTap: () async {
              Map<String, dynamic> data =
                  await Get.to(() => SalesPersonListScreen(
                        isToSelectPerson: true,
                        fromPage: FromPage.CreateTaskPage,
                      ));

              if (data != null && mounted) {
                if (data.containsKey("selectedPersonInfo")) {
                  if (_monthWiseReportBloc != null) {
                    _monthWiseReportBloc.presentDates = [];
                  }
                  setState(() {
                    salesPersonReceived = data["selectedPersonInfo"];
                  });
                }
              }
            },
          ),
        );
      } else {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                border: Border.all(width: 2, color: Colors.black87),
              ),
              child: Image.asset('assets/images/ic_avatar.png')),
          title: Text('Add Person'),
          trailing: AppButton.elevated(
            text: 'Add',
            onTap: () async {
              Map<String, dynamic> data =
                  await Get.to(() => SalesPersonListScreen(
                        isToSelectPerson: true,
                        fromPage: FromPage.CalenderPage,
                      ));

              if (data != null && mounted) {
                if (data.containsKey("selectedPersonInfo")) {
                  setState(() {
                    salesPersonReceived = data["selectedPersonInfo"];
                  });
                }
              }
            },
          ),
        );
      }
    } else {
      return Container();
    }
  }

  getImage() {
    String img = "";
    if (salesPersonReceived != null) {
      if (salesPersonReceived.image != null) {
        if (salesPersonReceived.image != "") {
          img = salesPersonReceived.image;
        }
      }
    }
    return img;
  }

  Widget _buildUserWidget() {
    if (_monthWiseReportBloc.presentDates != null) {
      return _buildCalenderReport();
    } else {
      return Container(
        child: Text(
          "Unable to fetch month report, please try again later",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: Color(colorCodeBlack),
              fontSize: 12.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500),
        ),
      );
    }
  }

  void _backPressFunction() {
    print("clicked");
    Get.back();
  }

  applyFilter() {
    if (_month == '' || _year == 0) {
      Fluttertoast.showToast(
          msg: "It is mandatory to select month, year and sales person");
    } else if (LoginModel().userDetails.role == "admin") {
      if (salesPersonReceived == null) {
        Fluttertoast.showToast(
            msg: "It is mandatory to select month, year and sales person");
      } else {
        _yearToFilter = _year;
        _monthToFilter = _month;
        _monthWiseReportBloc.getMonthReport(
            getMonthVal(), _year, salesPersonReceived.id);
      }
    } else {
      _yearToFilter = _year;
      _monthToFilter = _month;
      _monthWiseReportBloc.getMonthReport(
          getMonthVal(), _year, LoginModel().userDetails.id);
    }
  }

  int getMonthVal() {
    if (_month == 'January') {
      return 1;
    } else if (_month == 'February') {
      return 2;
    } else if (_month == 'March') {
      return 3;
    } else if (_month == 'April') {
      return 4;
    } else if (_month == 'May') {
      return 5;
    } else if (_month == 'June') {
      return 6;
    } else if (_month == 'July') {
      return 7;
    } else if (_month == 'August') {
      return 8;
    } else if (_month == 'September') {
      return 9;
    } else if (_month == 'October') {
      return 10;
    } else if (_month == 'November') {
      return 11;
    } else if (_month == 'December') {
      return 12;
    } else {
      return -1;
    }
  }

  int getMonthFilterVal() {
    if (_monthToFilter == 'January') {
      return 1;
    } else if (_monthToFilter == 'February') {
      return 2;
    } else if (_monthToFilter == 'March') {
      return 3;
    } else if (_monthToFilter == 'April') {
      return 4;
    } else if (_monthToFilter == 'May') {
      return 5;
    } else if (_monthToFilter == 'June') {
      return 6;
    } else if (_monthToFilter == 'July') {
      return 7;
    } else if (_monthToFilter == 'August') {
      return 8;
    } else if (_monthToFilter == 'September') {
      return 9;
    } else if (_monthToFilter == 'October') {
      return 10;
    } else if (_monthToFilter == 'November') {
      return 11;
    } else if (_monthToFilter == 'December') {
      return 12;
    } else {
      return -1;
    }
  }

  _buildCalenderReport() {
    _currentDate = DateTime(_yearToFilter, getMonthFilterVal(), 1);
    _markedDateMap = new EventList<Event>(
      events: {},
    );
    for (int i = 0; i < _monthWiseReportBloc.presentDates.length; i++) {
      _markedDateMap.add(
        _monthWiseReportBloc.presentDates[i],
        new Event(
          date: _monthWiseReportBloc.presentDates[i],
          title: 'Busy',
          icon: _presentIcon(
            _monthWiseReportBloc.presentDates[i].day.toString(),
          ),
        ),
      );
    }
    return CalendarCarousel<Event>(
      height: MediaQuery.of(context).size.height * 0.64,
      dayPadding: 4,
      selectedDateTime: _currentDate,
      targetDateTime: _currentDate,
      dayButtonColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.grey,
      selectedDayButtonColor: Colors.transparent,
      selectedDayBorderColor: Colors.grey,
      /*onDayPressed: (date, events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },*/
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      //firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.green)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: true,
      showHeaderButton: false,
      /*todayTextStyle: TextStyle(
        color: Colors.blue,
      ),*/
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      markedDateMoreShowTotal: null,
      //todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.black,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      onDayLongPressed: null,
      isScrollable: false,
      onLeftArrowPressed: () {},
      onRightArrowPressed: () {},
    );
  }
}
