import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/widgets/components/activity_info_dialog.dart';

class ActivityCard extends StatefulWidget {
  final TimetableItem timetableItem;
  final DateTime dateTime;
  final ITextLocalizer textLocalizer;
  final String? updateId;
  final _ActivityCardType _activityCardType;

  ActivityCard.simple({
    required this.timetableItem,
    required this.dateTime,
    required this.textLocalizer,
    this.updateId,
  }) : this._activityCardType = _ActivityCardType.Simple;

  ActivityCard.canceled({
    required this.timetableItem,
    required this.dateTime,
    required this.textLocalizer,
    this.updateId,
  }) : this._activityCardType = _ActivityCardType.Canceled;

  ActivityCard.current({
    required this.timetableItem,
    required this.dateTime,
    required this.textLocalizer,
    this.updateId,
  }) : this._activityCardType = _ActivityCardType.Current;

  ActivityCard.added({
    required this.timetableItem,
    required this.dateTime,
    required this.textLocalizer,
    this.updateId,
  }) : this._activityCardType = _ActivityCardType.Added;

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  late final TimetableBloc timetableBloc;
  late final Tutor tutor;
  late final List<String> unavailableTimes;

  @override
  void initState() {
    timetableBloc = context.read<TimetableBloc>();
    tutor = context.read<Tutor>();
    unavailableTimes = context.read<List<String>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(widget.updateId == null
          ? ''
          : widget.updateId! + '/' + widget.dateTime.toString()),
      onTap: _showActivityInfoDialog,
      child: Container(
        color: _getBackgroundColor(context),
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
                        widget.timetableItem.activity.time.start,
                        textScaleFactor: 1.3,
                      ),
                      Text(
                        widget.timetableItem.activity.time.end,
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
                        widget.timetableItem.activity.name,
                        textScaleFactor: 1.3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.textLocalizer.localize('aud.') +
                            ' ' +
                            widget.timetableItem.activity.room +
                            ', ' +
                            widget.timetableItem.activity.type,
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
                        widget.timetableItem.activity.tutors
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

  Color? _getBackgroundColor(BuildContext context) {
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

  void _showActivityInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => ActivityInfoDialog(
        timetableItem: widget.timetableItem,
        textLocalizer: widget.textLocalizer,
        onCancel: () async {
          Navigator.pop(context);
          timetableBloc.cancelLesson(
            widget.timetableItem.activity,
            widget.dateTime,
            widget.timetableItem.weekNumber,
            widget.timetableItem.dayNumber,
          );
        },
        isUpdated: widget.updateId != null,
        onUpdateCancel: () async {
          if (widget.updateId != null) {
            Navigator.pop(context);
            timetableBloc.deleteTimetableUpdate(
              widget.updateId!,
              widget.timetableItem.weekNumber,
              widget.timetableItem.dayNumber,
            );
          }
        },
        dateTime: widget.dateTime,
        tutor: tutor,
        unavailableTimes: unavailableTimes,
      ),
    );
  }
}

enum _ActivityCardType {
  Simple,
  Canceled,
  Added,
  Current,
}