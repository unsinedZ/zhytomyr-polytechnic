import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';

class ActivityCard extends StatefulWidget {
  final Activity activity;
  final DateTime dateTime;

  ActivityCard({required this.activity, required this.dateTime});

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  late bool isCurrentClass;

  @override
  void initState() {
    isCurrentClass = false;

    if (DateTime.now().asDate().difference(widget.dateTime.asDate()).inDays == 0) {
      List<String> timeStart = widget.activity.time.start.split(':');
      List<String> timeEnd = widget.activity.time.end.split(':');

      DateTime dateTimeStart = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeStart[0]),
          minutes: int.parse(timeStart[1])));
      DateTime dateTimeEnd = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeEnd[0]),
          minutes: int.parse(timeEnd[1])));

      if (DateTime.now().isAfter(dateTimeStart) && DateTime.now().isBefore(dateTimeEnd)) {
        isCurrentClass = true;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isCurrentClass ? Theme.of(context).accentColor : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
        child: IntrinsicHeight(
          child: Row(
            children: [
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minWidth: 45.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.activity.time.start,
                      textScaleFactor: 1.3,
                    ),
                    Text(
                      widget.activity.time.end,
                      style: Theme.of(context).textTheme.headline2,
                      textScaleFactor: 1.3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 7,
              ),
              VerticalDivider(
                thickness: 2,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.activity.name,
                    textScaleFactor: 1.3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.activity.room,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.activity.tutor.name,
                    style: Theme.of(context).textTheme.headline2,
                    textScaleFactor: 1.15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
