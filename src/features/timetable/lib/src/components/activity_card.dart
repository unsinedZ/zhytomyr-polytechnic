import 'package:flutter/material.dart';

import 'package:timetable/src/models/models.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard({required this.activity}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activity.time.start,
                  textScaleFactor: 1.3,
                ),
                Text(
                  activity.time.end,
                  style: Theme.of(context).textTheme.headline2,
                  textScaleFactor: 1.3,
                ),
              ],
            ),
            SizedBox(
              width: 7,
            ),
            VerticalDivider(thickness: 2, color: Theme.of(context).primaryColor,),
            SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  activity.name,
                  textScaleFactor: 1.3,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  activity.room,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  activity.tutor.name,
                  style: Theme.of(context).textTheme.headline2,
                  textScaleFactor: 1.15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
