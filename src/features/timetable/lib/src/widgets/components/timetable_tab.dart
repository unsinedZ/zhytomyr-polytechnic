import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:timetable/src/bl/abstractions/text_localizer.dart';

import 'package:timetable/src/bl/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timetable/src/widgets/timetable_screen.dart';

import 'activity_card.dart';

class TimetableTab extends StatelessWidget {
  final TextLocalizer textLocalizer;
  final Timetable timetable;
  final int weekNumber;
  final int dayOfWeekNumber;
  final DateTime dateTime;
  final TimetableType timetableType;
  final String id;
  final String? subgroupId;

  TimetableTab({
    required this.textLocalizer,
    required this.timetable,
    required this.weekNumber,
    required this.dayOfWeekNumber,
    required this.dateTime,
    required this.timetableType,
    required this.id,
    this.subgroupId,
  }) : super();

  @override
  Widget build(BuildContext context) {
    List<Widget> activityCards = timetable.items!
        .where((timetableItem) =>
            timetableItem.weekNumber == weekNumber &&
            timetableItem.dayNumber == dayOfWeekNumber)
        .map((timetableItem) => timetableItem.activity)
        .where((activity) {
          if (timetableType == TimetableType.Group) {
            return activity.groups.any((group) =>
                group.id == id &&
                (group.subgroups == null ||
                    group.subgroups!.length == 1 ||
                    subgroupId == null ||
                    group.subgroups!
                        .any((subgroup) => subgroup.id == subgroupId)));
          }

          if (timetableType == TimetableType.Teacher) {
            return activity.tutor.id == id;
          }
          return false;
        })
        .map((activity) => ActivityCard(
              activity: activity,
            ))
        .expand((element) => [Divider(), element])
        .skip(1)
        .toList();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat('d MMMM', context.locale.toString()).format(dateTime),
          ),
        ),
        ...activityCards,
        if(activityCards.isNotEmpty)
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
                        textLocalizer.localize('DAY OFF'),
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
