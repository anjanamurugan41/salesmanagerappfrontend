import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';
import 'package:sales_manager_app/Models/TaskItem.dart';

import 'app_card.dart';

class TaskListItem extends StatelessWidget {
  final VoidCallback onTap;
  final TaskItem taskItem;

  const TaskListItem({Key key, @required this.onTap, @required this.taskItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
        child: IntrinsicHeight(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  margin: EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    color: Color(buttonBgColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${taskItem.title}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Assigned by  ${taskItem.task_created}',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: Colors.black45,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${taskItem.date}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 18),
                          Icon(
                            CupertinoIcons.time,
                            color: Colors.black45,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${taskItem.time}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  getIcon(taskItem),
                  fit: BoxFit.fill,
                  width: 30,
                  height: 30,
                )
              ]),
        ),
      ),
      onTap: onTap,
    );
  }

  String getIcon(TaskItem taskItem) {
    if (taskItem.status == 0) {
      return 'assets/images/ic_complete.png';
    } else if (taskItem.status == 1) {
      return 'assets/images/ic_pending.png';
    } else if (taskItem.status == 2) {
      return 'assets/images/ic_reject.png';
    } else if (taskItem.status == 3) {
      return 'assets/images/ic_rescheduled.png';
    }
    else {
      return 'assets/images/ic_pending.png';
    }
  }
}
