import 'package:flutter/material.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';

class ActivityInfoDialog extends StatelessWidget {
  final ITextLocalizer textLocalizer;
  final Activity activity;

  ActivityInfoDialog({
    required this.activity,
    required this.textLocalizer,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    activity.name,
                    textScaleFactor: 1.5,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RichText(
                  textScaleFactor: 1.1,
                  text: TextSpan(
                    text: textLocalizer.localize('Teacher: '),
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(
                          text: activity.tutors.map((tutor) => tutor.name).join(', '),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  textScaleFactor: 1.1,
                  text: TextSpan(
                    text: textLocalizer.localize('Groups: '),
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(
                          text: activity.groups
                              .map((group) => group.name)
                              .join(', '),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  textScaleFactor: 1.1,
                  text: TextSpan(
                    text: textLocalizer.localize('Auditory: '),
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(
                          text: activity.room,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: IconButton(
              alignment: Alignment.topRight,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.black,),
            ),
          )
        ],
      ),
    );
  }
}
