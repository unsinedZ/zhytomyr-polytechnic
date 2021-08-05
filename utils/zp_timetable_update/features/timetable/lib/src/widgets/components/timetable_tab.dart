import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/bl/extensions/date_time_extension.dart';
import 'package:timetable/src/widgets/components/components.dart';

class TimetableTab extends StatefulWidget {
  final ITextLocalizer textLocalizer;
  final Timetable timetable;
  final List<TimetableItemUpdate> timetableItemUpdates;
  final int weekNumber;
  final int dayOfWeekNumber;
  final DateTime dateTime;
  final int id;
  final bool isTomorrow;
  final int? subgroupId;

  TimetableTab({
    required this.textLocalizer,
    required this.timetable,
    required this.timetableItemUpdates,
    required this.weekNumber,
    required this.dayOfWeekNumber,
    required this.dateTime,
    required this.id,
    required this.isTomorrow,
    this.subgroupId,
  }) : super();

  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  //late List<Widget> widgets;
  late List<TimetableItemUpdate> timetableItemUpdates;

  late final AuthClient authClient;
  late final Tutor tutor;
  late final TimetableBloc timetableBloc;

  @override
  void initState() {
    initializeDateFormatting();

    timetableBloc = context.read<TimetableBloc>();
    authClient = context.read<AuthClient>();
    tutor = context.read<Tutor>();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimetableTab oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = stateToWidgets();

    return SingleChildScrollView(
      key: Key(widget.weekNumber.toString() +
          '/' +
          widget.dayOfWeekNumber.toString() +
          '/' +
          timetableItemUpdates.length.toString()),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (widget.isTomorrow == true
                  ? widget.textLocalizer.localize('Tomorrow')
                  : DateFormat('d MMMM', 'uk').format(widget.dateTime)),
            ),
          ),
          ...widgets,
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/update_form', arguments: {
                    'client': authClient,
                    'dateTime': widget.dateTime,
                    'onUpdateCreated': () async {
                      await timetableBloc
                          .loadTimetableItemUpdates()
                          .then((value) {});
                    },
                    'dayNumber': widget.dayOfWeekNumber,
                    'weekNumber': widget.weekNumber,
                    'tutorJson': tutor.toJson(),
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Додати нову пару',
                    textScaleFactor: 1.3,
                  ),
                ),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Theme.of(context).disabledColor;
                    }
                    return Color(0xff36d02b);
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool filterByTimetableType(TimetableItem timetableItem) {
    return timetableItem.activity.tutors.any((tutor) => tutor.id == widget.id);
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

      if (widget.dateTime.asDate().isAtSameMomentAs(dateTime.asDate())) {
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
    if (timetableItemUpdates.isNotEmpty) {
      List<TimetableItemUpdate> updates =
          timetableItemUpdates.where((timetableUpdate) {
        String updateItemTime = timetableUpdate.time;
        String activityStartTime = timetableItem!.activity.time.start;

        DateTime dateTime =
            DateTime.parse(timetableUpdate.date.replaceAll('/', '-'));

        return widget.dateTime.asDate().isAtSameMomentAs(dateTime) &&
            updateItemTime == activityStartTime;
      }).toList();

      if (updates.length == 1) {
        timetableItemUpdate = updates.first;
      }

      if (updates.length > 1) {
        List<TimetableItemUpdate> updatesWithItem =
            updates.where((update) => update.timetableItem != null).toList();
        if(updatesWithItem.isNotEmpty) {
          timetableItemUpdate = updatesWithItem.first;
        } else {
          timetableItemUpdate = updates.first;
        }
      }
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
