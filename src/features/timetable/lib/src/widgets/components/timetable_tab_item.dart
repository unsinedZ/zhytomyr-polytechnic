import 'package:flutter/material.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';
import 'package:timetable/src/widgets/components/components.dart';

class TimetableTabItem extends StatefulWidget {
  final Activity activity;
  final List<TimetableItemUpdate> timetableItemUpdates;
  final DateTime dateTime;
  final TextLocalizer textLocalizer;
  final bool isNew;

  TimetableTabItem({
    required this.activity,
    required this.timetableItemUpdates,
    required this.dateTime,
    required this.textLocalizer,
    required this.isNew,
  });

  @override
  _TimetableTabItemState createState() => _TimetableTabItemState();
}

class _TimetableTabItemState extends State<TimetableTabItem> {
  late bool isCurrentClass = false;
  late bool isUpdated = false;

  TimetableItemUpdate? timetableItemUpdate;

  @override
  void initState() {
    if (DateTime.now().asDate().difference(widget.dateTime.asDate()).inDays ==
        0) {
      List<String> timeStart = widget.activity.time.start.split(':');
      List<String> timeEnd = widget.activity.time.end.split(':');

      DateTime dateTimeStart = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeStart[0]), minutes: int.parse(timeStart[1])));
      DateTime dateTimeEnd = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeEnd[0]), minutes: int.parse(timeEnd[1])));

      if (DateTime.now().isAfter(dateTimeStart) &&
          DateTime.now().isBefore(dateTimeEnd)) {
        isCurrentClass = true;
      }
    }

    if (widget.timetableItemUpdates.isNotEmpty && !widget.isNew) {
      widget.timetableItemUpdates.forEach((timetableItemUpdate) {
        String updateTime = timetableItemUpdate.time;
        String activityStartTime = widget.activity.time.start;

        DateTime dateTime = DateTime.parse(timetableItemUpdate.date.replaceAll('/', '-'));

        if (widget.dateTime.asDate().isAtSameMomentAs(dateTime) &&
            updateTime == activityStartTime) {
          isUpdated = true;
          this.timetableItemUpdate = timetableItemUpdate;
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActivityCard(
          backgroundColor: isUpdated
              ? Theme.of(context).disabledColor
              : isCurrentClass
                  ? Theme.of(context).accentColor
                  : widget.isNew
                      ? Theme.of(context).selectedRowColor
                      : null,
          textLocalizer: widget.textLocalizer,
          activity: widget.activity,
        ),
        if (isUpdated && timetableItemUpdate!.timetableItem != null)
          ...[
          Icon(
            Icons.arrow_downward,
            color: Colors.black,
          ),
          ActivityCard(
            backgroundColor: isCurrentClass
                ? Theme.of(context).accentColor
                : Theme.of(context).selectedRowColor,
            textLocalizer: widget.textLocalizer,
            activity: timetableItemUpdate!.timetableItem!.activity,
          ),
        ],
      ],
    );
  }
}
