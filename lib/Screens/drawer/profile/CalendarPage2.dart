import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class CalendarPage2 extends StatefulWidget {
  @override
  _CalendarPage2State createState() => new _CalendarPage2State();
}

List<DateTime> presentDates = [
  DateTime(2020, 09, 1),
  DateTime(2020, 09, 3),
  DateTime(2020, 09, 4),
  DateTime(2020, 09, 5),
  DateTime(2020, 09, 6),
  DateTime(2020, 09, 8),
  DateTime(2020, 09, 9),
  DateTime(2020, 09, 10),
  DateTime(2020, 09, 11),
  DateTime(2020, 09, 15),
  DateTime(2020, 09, 22),
  DateTime(2020, 09, 23),
];


class _CalendarPage2State extends State<CalendarPage2> {
  DateTime _currentDate = DateTime(2020, 09, 1);

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

  CalendarCarousel _calendarCarouselNoHeader;

  //var len = min(absentDates?.length, presentDates.length);
  var len = presentDates.length;
  double cHeight;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < len; i++) {
      _markedDateMap.add(
        presentDates[i],
        new Event(
          date: presentDates[i],
          title: 'Event 5',
          icon: _presentIcon(
            presentDates[i].day.toString(),
          ),
        ),
      );
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight * 0.64,
      dayPadding: 4,
      selectedDateTime: _currentDate,
      targetDateTime: _currentDate,
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
      //markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: Colors.green)),
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
      markedDateMoreShowTotal: false,
      //todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      onDayLongPressed: null,
      isScrollable: false,
      onLeftArrowPressed: (){},
      onRightArrowPressed: (){},
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Calender"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _calendarCarouselNoHeader,
          ],
        ),
      ),
    );
  }

}
