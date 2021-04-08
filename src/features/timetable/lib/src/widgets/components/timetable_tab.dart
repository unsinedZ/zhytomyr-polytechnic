import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:timetable/src/bl/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timetable/src/widgets/timetable_screen.dart';

import 'activity_card.dart';

class TimetableTab extends StatelessWidget {
  final Timetable timetable;
  final int weekNumber;
  final int dayOfWeekNumber;
  final DateTime dateTime;
  final TimetableType timetableType;
  final String id;

  TimetableTab({
    required this.timetable,
    required this.weekNumber,
    required this.dayOfWeekNumber,
    required this.dateTime,
    required this.timetableType,
    required this.id,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              DateFormat('d MMMM', context.locale.toString()).format(dateTime)),
        ),
        ...timetable.items!
            .where((timetableItem) => timetableItem.weekNumber == weekNumber && timetableItem.dayNumber == dayOfWeekNumber)
            .map((timetableItem) => timetableItem.activity)
            .where((activity) {
              if (timetableType == TimetableType.Group) {
                return activity.groups.any((group) => group.id == id);
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
            .toList(),
      ],
    );
  }
}
