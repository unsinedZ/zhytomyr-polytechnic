import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/widgets/components/activity_card.dart';
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
  @override
  Widget build(BuildContext context) {
    List<Widget> activityCards = widget.timetable.items!
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
        })
        .map((activity) => ActivityCard(
              activity: activity,
              timetableItemUpdates: widget.timetableItemUpdates,
              textLocalizer: widget.textLocalizer,
              dateTime: widget.dateTime,
            ))
        .expand((element) => [Divider(), element])
        .skip(1)
        .toList();

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
        ...activityCards,
        if (activityCards.isEmpty)
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
}
