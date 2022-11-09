import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';
import 'package:stacked_notification_cards/stacked_notification_cards.dart';

import 'app_card.dart';

class NotificationListItem extends StatelessWidget {
  final VoidCallback onTap;
  final names;


  NotificationListItem({Key key, @required this.onTap, @required this.names})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("dd-MM-yyyy");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    List<NotificationCard> _listOfNotification = [
      NotificationCard(
        date: DateTime.now(),
        leading: Icon(
          Icons.account_circle,
          size: 48,
        ),
        title: 'Task',
        subtitle: '$names Assigned Task',
      ),
    ];
    return Column(
      children: [
        StackedNotificationCards(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 2.0,
            )
          ],
          notificationCardTitle: 'Message',
          notificationCards: [..._listOfNotification],
          cardColor: Colors.grey[300],
          padding: 8,
          actionTitle: Text('',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          showLessAction: Text(
            'Show less',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          onTapClearAll: () {
            _listOfNotification.clear();
          },
          clearAllNotificationsAction: Icon(Icons.close),
          clearAllStacked: Text('Clear All'),
          cardClearButton: Text('clear'),
          cardViewButton: Text('view'),
          onTapClearCallback: (index) {
            print(index);
            _listOfNotification.removeAt(index);
          },
          onTapViewCallback: (index) {
            print(index);
          },
        ),
      ],
    );
  }

}

