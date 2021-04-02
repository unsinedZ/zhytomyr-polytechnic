import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetable_screen/src/models/models.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard({required this.activity}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff35b9ca),
              borderRadius: BorderRadius.all(Radius.circular(5000)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                width: 25,
                height: 25,
                child: Center(
                  child: Text(
                    activity.name[0],
                    textScaleFactor: 2,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.name,
                textScaleFactor: 1.3,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                activity.tutor.name,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 8,
              ),
              Text(activity.room),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(activity.groups.length.toString()),
              SizedBox(height: 35),
              Text(
                activity.time.start + ' - ' + activity.time.end,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
