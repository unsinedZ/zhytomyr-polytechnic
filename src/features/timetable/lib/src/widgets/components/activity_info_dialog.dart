import 'package:flutter/material.dart';
import 'package:timetable/src/bl/models/models.dart';

class ActivityInfoDialog extends StatelessWidget {
  final Activity activity;

  ActivityInfoDialog({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(activity.name),
        Text(activity.tutor.name),
        Text(activity.groups.map((group) => group.name).join(', ')),
        //.fold('', (previousValue, group) => previousValue + ' ,' + group.name)),
        Text(activity.room),
      ],
    );
  }
}
