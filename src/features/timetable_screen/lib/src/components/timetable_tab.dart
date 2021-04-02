import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:timetable_screen/src/models/models.dart';
import 'package:easy_localization/easy_localization.dart';

import 'activity_card.dart';

class TimetableTab extends StatelessWidget {
  final Timetable timetable;
  final int weekNumber;
  final DateTime dateTime;

  TimetableTab(
      {required this.timetable,
      required this.weekNumber,
      required this.dateTime})
      : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(DateFormat('d MMMM', context.locale.toString()).format(dateTime)),
            )
          ] +
          timetable.items!
              .where((timetableItem) => timetableItem.weekNumber == weekNumber)
              .map((timetableItem) => timetableItem.activity!)
              .toList()
              .map((activity) => ActivityCard(
                    activity: activity,
                  ))
              .toList() +
          [
            SizedBox(
              height: 15,
            )
          ],
    );
  }
}
