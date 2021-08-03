import 'package:flutter/material.dart';

import 'package:googleapis_auth/auth_io.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';

class ActivityInfoDialog extends StatefulWidget {
  final ITextLocalizer textLocalizer;
  final TimetableItem timetableItem;
  final DateTime dateTime;
  final VoidCallback onCancel;
  final VoidCallback onUpdateCancel;
  final VoidCallback onUpdateCreated;
  final bool isUpdated;
  final AuthClient authClient;
  final Tutor tutor;

  ActivityInfoDialog({
    required this.timetableItem,
    required this.textLocalizer,
    required this.dateTime,
    required this.onCancel,
    required this.onUpdateCancel,
    required this.onUpdateCreated,
    required this.isUpdated,
    required this.authClient,
    required this.tutor,
  });

  @override
  _ActivityInfoDialogState createState() => _ActivityInfoDialogState();
}

class _ActivityInfoDialogState extends State<ActivityInfoDialog> {

  @override
  void initState() {
    super.initState();
  }

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
                    widget.timetableItem.activity.name,
                    textScaleFactor: 1.5,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RichText(
                  textScaleFactor: 1.1,
                  text: TextSpan(
                    text: widget.textLocalizer.localize('Teacher: '),
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.timetableItem.activity.tutors
                              .map((tutor) => tutor.name)
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
                    text: widget.textLocalizer.localize('Groups: '),
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.timetableItem.activity.groups
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
                    text: widget.textLocalizer.localize('Auditory: '),
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.timetableItem.activity.room,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                if (!widget.isUpdated) ...[
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/update_form',
                            arguments: {
                              'client': widget.authClient,
                              'timetableItemJson': widget.timetableItem.toJson(),
                              'dateTime': widget.dateTime,
                              'onUpdateCreated': widget.onUpdateCreated,
                              'dayNumber': widget.timetableItem.dayNumber,
                              'weekNumber': widget.timetableItem.weekNumber,
                              'tutorJson': widget.tutor.toJson(),
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Створити заміну',
                          textScaleFactor: 1.3,
                        ),
                      ),
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Theme.of(context).disabledColor;
                          }
                          return Color(0xff36d02b);
                        }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onCancel,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Відмінити',
                          textScaleFactor: 1.3,
                        ),
                      ),
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Theme.of(context).disabledColor;
                          }
                          return Color(0xffff4b4b);
                        }),
                      ),
                    ),
                  )
                ],
                if (widget.isUpdated) ...[
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onUpdateCancel,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Відмінити заміну',
                          textScaleFactor: 1.3,
                        ),
                      ),
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Theme.of(context).disabledColor;
                          }
                          return Color(0xffff4b4b);
                        }),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: IconButton(
              hoverColor: Color(0xFF0000),
              alignment: Alignment.topRight,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
