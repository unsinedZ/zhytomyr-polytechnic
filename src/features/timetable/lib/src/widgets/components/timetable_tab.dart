import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';
import 'package:timetable/src/widgets/components/components.dart';
import 'package:timetable/src/widgets/timetable_screen.dart';

class TimetableTab extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final Timetable timetable;
  final List<TimetableItemUpdate> timetableItemUpdates;
  final int weekNumber;
  final int dayOfWeekNumber;
  final DateTime dateTime;
  final TimetableType timetableType;
  final String id;
  final bool isTomorrow;
  final String? subgroupId;

  TimetableTab({
    required this.textLocalizer,
    required this.timetable,
    required this.timetableItemUpdates,
    required this.weekNumber,
    required this.dayOfWeekNumber,
    required this.dateTime,
    required this.timetableType,
    required this.id,
    required this.isTomorrow,
    this.subgroupId,
  }) : super();

  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  late List<Widget> widgets;
  late List<TimetableItemUpdate> timetableItemUpdates;

  @override
  void initState() {
    widgets = stateToWidgets();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimetableTab oldWidget) {
    setState(() {
      widgets = stateToWidgets();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (widget.isTomorrow == true
                  ? widget.textLocalizer.localize('Tomorrow ')
                  : DateFormat('d MMMM', context.locale.toString())
                      .format(widget.dateTime)),
            ),
          ),
          ...widgets,
          if (widgets.isEmpty) ...[
            SizedBox(
              height: 120,
            ),
            Image.asset(
              'assets/images/day_off.png',
              package: 'timetable',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.textLocalizer.localize('DAY OFF'),
              textScaleFactor: 1.7,
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ],
      ),
    );
  }

  bool filterByTimetableType(TimetableItem timetableItem) {
    if (widget.timetableType == TimetableType.Group) {
      return timetableItem.activity.groups.any((group) =>
          group.id == widget.id &&
          (group.subgroups.isEmpty ||
              widget.subgroupId == null ||
              widget.subgroupId == '' ||
              group.subgroups
                  .any((subgroup) => subgroup.id == widget.subgroupId)));
    }

    if (widget.timetableType == TimetableType.Teacher) {
      return timetableItem.activity.tutor.id == widget.id;
    }
    return false;
  }

  List<Widget> stateToWidgets() {
    List<TimetableItem> timetableItems = widget.timetable.items
        .where((timetableItem) =>
            timetableItem.weekNumber == widget.weekNumber &&
            timetableItem.dayNumber == widget.dayOfWeekNumber)
        .where((timetableItem) => filterByTimetableType(timetableItem))
        .toList();

    timetableItemUpdates =
        widget.timetableItemUpdates.where((timetableItemUpdate) {
      DateTime dateTime =
          DateTime.parse(timetableItemUpdate.date.replaceAll('/', '-'));

      if (widget.dateTime.asDate().isAtSameMomentAs(dateTime)) {
        if (timetableItemUpdate.timetableItem == null ||
            filterByTimetableType(timetableItemUpdate.timetableItem!)) {
          return true;
        }
      }
      return false;
    }).toList();

    List<UpdatableTimetableItem> updatableTimetableItems = timetableItems
        .map(
          (timetableItem) => createUpdatableItem(
              timetableItemUpdates: timetableItemUpdates,
              timetableItem: timetableItem),
        )
        .toList();

    List<UpdatableTimetableItem> newUpdatableTimetableItems =
        timetableItemUpdates
            .where((timetableItemUpdate) => timetableItems.every(
                (timetableItem) =>
                    timetableItem.activity.time.start !=
                        timetableItemUpdate.time &&
                    timetableItemUpdate.timetableItem != null))
            .map((timetableItemUpdate) => createUpdatableItem(
                timetableItemUpdates: [],
                timetableItemUpdate: timetableItemUpdate))
            .toList();

    updatableTimetableItems.addAll(newUpdatableTimetableItems);

    updatableTimetableItems = updatableTimetableItems
        .where((updatableTimetableItem) => !updatableTimetableItem.isEmpty)
        .toList();

    updatableTimetableItems.sort((a, b) => a.compareTo(b));

    return updatableTimetableItems
        .map((updatableTimetableItem) => TimetableTabItem(
              updatableTimetableItem: updatableTimetableItem,
              textLocalizer: widget.textLocalizer,
              dateTime: widget.dateTime,
            ))
        .expand((element) => [
              Divider(
                height: 1,
                thickness: 1,
              ),
              element
            ])
        .skip(1)
        .toList();
  }

  UpdatableTimetableItem createUpdatableItem({
    required List<TimetableItemUpdate> timetableItemUpdates,
    TimetableItem? timetableItem,
    TimetableItemUpdate? timetableItemUpdate,
  }) {
    print('createUpdatableItem');
    if (timetableItemUpdates.isNotEmpty) {
      timetableItemUpdates.forEach((timetableUpdate) {
        String updateItemTime = timetableUpdate.time;
        String activityStartTime = timetableItem!.activity.time.start;

        DateTime dateTime =
            DateTime.parse(timetableUpdate.date.replaceAll('/', '-'));

        if (widget.dateTime.asDate().isAtSameMomentAs(dateTime) &&
            updateItemTime == activityStartTime) {
          timetableItemUpdate = timetableUpdate;
        }
      });
    }

    if (timetableItem != null || timetableItemUpdate != null) {
      return UpdatableTimetableItem(
          timetableItem: timetableItem,
          timetableItemUpdate: timetableItemUpdate);
    } else {
      throw ArgumentError.notNull('timetableItem || timetableItemUpdate');
    }
  }
}
