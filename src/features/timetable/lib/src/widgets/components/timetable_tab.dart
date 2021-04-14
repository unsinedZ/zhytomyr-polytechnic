import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';
import 'package:timetable/src/bl/extensions/string_extension.dart';
import 'package:timetable/src/widgets/components/components.dart';
import 'package:timetable/src/widgets/timetable_screen.dart';

class TimetableTab extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final Timetable timetable;
  final List<TimetableItemUpdate> timetableItemUpdates;
  final int weekNumber;
  final int dayOfWeekNumber;
  final DateTime dateTime;
  final TimetableType timetableType;
  final String id;
  final bool isTomorrow;
  final String? subgroupId;

  TimetableTab({
    required this.textLocalizer,
    required this.timetable,
    required this.timetableItemUpdates,
    required this.weekNumber,
    required this.dayOfWeekNumber,
    required this.dateTime,
    required this.timetableType,
    required this.id,
    required this.isTomorrow,
    this.subgroupId,
  }) : super();

  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  late List<Widget> widgets;
  late List<TimetableItemUpdate> timetableItemUpdatesWithRightDate;

  @override
  void initState() {
    widgets = stateToWidgets();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimetableTab oldWidget) {
    setState(() {
      setState(() {
        widgets = stateToWidgets();
      });
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            (widget.isTomorrow == true
                    ? widget.textLocalizer.localize('Tomorrow ')
                    : '') +
                DateFormat('d MMMM', context.locale.toString())
                    .format(widget.dateTime),
          ),
        ),
        ...widgets,
        if (widgets.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/day_off.png',
                    package: 'timetable',
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.textLocalizer.localize('DAY OFF'),
                    textScaleFactor: 1.7,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  TimetableTabItem defaultTimetableTabItem({required activity, isNew = false}) {
    return TimetableTabItem(
      activity: activity,
      timetableItemUpdates: timetableItemUpdatesWithRightDate,
      textLocalizer: widget.textLocalizer,
      dateTime: widget.dateTime,
      isNew: isNew,
    );
  }

  List<Widget> stateToWidgets() {
    List<Activity> activities = widget.timetable.items!
        .where((timetableItem) =>
            timetableItem.weekNumber == widget.weekNumber &&
            timetableItem.dayNumber == widget.dayOfWeekNumber)
        .map((timetableItem) => timetableItem.activity)
        .where((activity) {
      if (widget.timetableType == TimetableType.Group) {
        return activity.groups.any((group) =>
            group.id == widget.id &&
            (group.subgroups == null ||
                group.subgroups!.length == 1 ||
                widget.subgroupId == null ||
                group.subgroups!
                    .any((subgroup) => subgroup.id == widget.subgroupId)));
      }

      if (widget.timetableType == TimetableType.Teacher) {
        return activity.tutor.id == widget.id;
      }
      return false;
    }).toList();

    timetableItemUpdatesWithRightDate =
        widget.timetableItemUpdates.where((timetableItemUpdate) {
      DateTime dateTime = DateTime.parse(timetableItemUpdate.date.replaceAll('/', '-'));

      if (widget.dateTime.asDate().isAtSameMomentAs(dateTime)) {
        return true;
      }
      return false;
    }).toList();

    List<TimetableTabItem> activityTabItems = activities
        .map((activity) => defaultTimetableTabItem(
      activity: activity,
    ))
        .toList();

    List<TimetableTabItem> newActivityTabItems =
        timetableItemUpdatesWithRightDate
            .where((timetableItemUpdate) => activities.every((activity) =>
                activity.time.start != timetableItemUpdate.time &&
                timetableItemUpdate.timetableItem != null))
            .map((timetableItemUpdate) => defaultTimetableTabItem(
                activity: timetableItemUpdate.timetableItem!.activity,
                isNew: true))
            .toList();

    activityTabItems.addAll(newActivityTabItems);

    activityTabItems.sort((a, b) {
      return a.activity.time.start.compareAsTimeTo(b.activity.time.start);
    });

    return activityTabItems
        .expand((element) => [
              Divider(
                height: 1,
                thickness: 1,
              ),
              element
            ])
        .skip(1)
        .toList();
  }
}
