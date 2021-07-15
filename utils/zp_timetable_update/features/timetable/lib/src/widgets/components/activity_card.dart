import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/widgets/components/activity_info_dialog.dart';

class ActivityCard extends StatefulWidget {
  final Activity activity;
  final DateTime dateTime;
  final ITextLocalizer textLocalizer;
  final _ActivityCardType _activityCardType;

  ActivityCard.simple({
    required this.activity,
    required this.dateTime,
    required this.textLocalizer,
  }) : this._activityCardType = _ActivityCardType.Simple;

  ActivityCard.canceled({
    required this.activity,
    required this.dateTime,
    required this.textLocalizer,
  }) : this._activityCardType = _ActivityCardType.Canceled;

  ActivityCard.current({
    required this.activity,
    required this.dateTime,
    required this.textLocalizer,
  }) : this._activityCardType = _ActivityCardType.Current;

  ActivityCard.added({
    required this.activity,
    required this.dateTime,
    required this.textLocalizer,
  }) : this._activityCardType = _ActivityCardType.Added;

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  late final TimetableBloc timetableBloc;

  @override
  void initState() {
    timetableBloc = context.read<TimetableBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) => ActivityInfoDialog(
            activity: widget.activity,
            textLocalizer: widget.textLocalizer,
            onCancel: () {
              timetableBloc.cancelLesson(widget.activity, widget.dateTime);
            },
          ),
        );
      },
      child: Container(
        color: getBackgroundColor(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minWidth: 45.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.activity.time.start,
                        textScaleFactor: 1.3,
                      ),
                      Text(
                        widget.activity.time.end,
                        style: Theme.of(context).textTheme.headline2,
                        textScaleFactor: 1.3,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                VerticalDivider(
                  thickness: 2,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.activity.name,
                        textScaleFactor: 1.3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.textLocalizer.localize('aud.') +
                            ' ' +
                            widget.activity.room +
                            ', ' +
                            widget.activity.type,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.activity.tutors
                            .map((tutor) => tutor.name)
                            .join(', '),
                        style: Theme.of(context).textTheme.headline2,
                        textScaleFactor: 1.15,
                      ),
                      if (this.widget._activityCardType ==
                          _ActivityCardType.Canceled)
                        Text(
                          widget.textLocalizer.localize('Canceled'),
                          style: TextStyle(color: Colors.red),
                          textScaleFactor: 1.15,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? getBackgroundColor(BuildContext context) {
    switch (this.widget._activityCardType) {
      case _ActivityCardType.Simple:
        return Theme.of(context).canvasColor;
      case _ActivityCardType.Canceled:
        return Theme.of(context).disabledColor;
      case _ActivityCardType.Added:
        return Theme.of(context).selectedRowColor;
      case _ActivityCardType.Current:
        return Theme.of(context).hoverColor;
    }
  }
}

enum _ActivityCardType {
  Simple,
  Canceled,
  Added,
  Current,
}
