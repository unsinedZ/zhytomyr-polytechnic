import 'package:flutter/material.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';
import 'package:timetable/src/widgets/components/components.dart';

class TimetableTabItem extends StatefulWidget {
  final UpdatableTimetableItem updatableTimetableItem;
  final DateTime dateTime;
  final ITextLocalizer textLocalizer;

  TimetableTabItem({
    required this.updatableTimetableItem,
    required this.dateTime,
    required this.textLocalizer,
  });

  @override
  _TimetableTabItemState createState() => _TimetableTabItemState();
}

class _TimetableTabItemState extends State<TimetableTabItem> {
  late bool isCurrentClass = false;

  bool get isNew => widget.updatableTimetableItem.isNew;

  bool get isCancelled => widget.updatableTimetableItem.isCancelled;

  bool get isReplaced => widget.updatableTimetableItem.isReplaced;

  TimetableItem? get mainTimetableItem =>
      widget.updatableTimetableItem.timetableItem;

  TimetableItem get timetableItemUpdate => widget
      .updatableTimetableItem.timetableItemUpdate!.timetableItem!;

  String? get activityUpdateId =>
      widget.updatableTimetableItem.timetableItemUpdate?.id;

  @override
  void initState() {
    if (DateTime.now().asDate().isAtSameMomentAs(widget.dateTime.asDate())) {
      TimetableItem timetableItem;

      if (isNew) {
        timetableItem = timetableItemUpdate;
      } else {
        timetableItem = mainTimetableItem!;
      }

      List<String> timeStart = timetableItem.activity.time.start.split(':');
      List<String> timeEnd = timetableItem.activity.time.end.split(':');

      DateTime dateTimeStart = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeStart[0]), minutes: int.parse(timeStart[1])));
      DateTime dateTimeEnd = DateTime.now().asDate().add(Duration(
          hours: int.parse(timeEnd[0]), minutes: int.parse(timeEnd[1])));

      if (DateTime.now().isAfter(dateTimeStart) &&
          DateTime.now().isBefore(dateTimeEnd)) {
        isCurrentClass = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isCancelled || isReplaced)
          ActivityCard.canceled(
            timetableItem: mainTimetableItem!,
            textLocalizer: widget.textLocalizer,
            dateTime: widget.dateTime,
            updateId: activityUpdateId,
          ),
        if (isReplaced)
          Icon(
            Icons.arrow_downward,
            color: Colors.black,
          ),
        isCurrentClass
            ? ActivityCard.current(
          timetableItem: mainTimetableItem ?? timetableItemUpdate, // TODO fix it in main app
                textLocalizer: widget.textLocalizer,
                dateTime: widget.dateTime,
                updateId: activityUpdateId,
              )
            : isReplaced || isNew
                ? ActivityCard.added(
          timetableItem: timetableItemUpdate,
                    textLocalizer: widget.textLocalizer,
                    dateTime: widget.dateTime,
                    updateId: activityUpdateId,
                  )
                : isCancelled
                    ? Container()
                    : ActivityCard.simple(
          timetableItem: mainTimetableItem!,
                        textLocalizer: widget.textLocalizer,
                        dateTime: widget.dateTime,
                        updateId: activityUpdateId,
                      ),
      ],
    );
  }
}
