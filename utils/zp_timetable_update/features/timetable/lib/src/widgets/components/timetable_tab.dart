import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:googleapis_auth/auth_io.dart';
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
  final bool isTomorrow;
  final int? subgroupId;

  TimetableTab({
    required this.textLocalizer,
    required this.timetable,
    required this.timetableItemUpdates,
    required this.weekNumber,
    required this.dayOfWeekNumber,
    required this.dateTime,
    required this.isTomorrow,
    this.subgroupId,
  }) : super();

  @override
  _TimetableTabState createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  late List<TimetableItemUpdate> timetableItemUpdates;

  late final AuthClient authClient;
  late final Tutor tutor;
  late final TimetableBloc timetableBloc;
  late List<UpdatableTimetableItem> updatableTimetableItems;
  late List<String> unavailableTimes;

  @override
  void initState() {
    initializeDateFormatting();

    timetableBloc = context.read<TimetableBloc>();
    tutor = context.read<Tutor>();

    updatableTimetableItems = stateToUpdatableItems();
    unavailableTimes = updatableTimetableItems.map((item) {
      if (item.timetableItemUpdate != null &&
          item.timetableItemUpdate!.timetableItem != null) {
        return item.timetableItemUpdate!.timetableItem!.activity.time.start;
      }

      if (item.timetableItem != null && item.isSimple) {
        return item.timetableItem!.activity.time.start;
      }
      return '';
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      key: Key(widget.weekNumber.toString() +
          '/' +
          widget.dayOfWeekNumber.toString() +
          '/'),
      providers: [
        Provider<List<String>>(create: (_) => unavailableTimes),
      ],
      child: SingleChildScrollView(
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
            ...updatableTimetableItems
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
                .toList(),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/update_form',
                      arguments: {
                        'unavailableTimes': unavailableTimes,
                        'dateTime': widget.dateTime,
                        'dayNumber': widget.dayOfWeekNumber,
                        'weekNumber': widget.weekNumber,
                        'tutorJson': tutor.toJson(),
                      },
                    );
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
      ),
    );
  }

  List<UpdatableTimetableItem> stateToUpdatableItems() {
    List<TimetableItem> timetableItems = widget.timetable.items
        .where((timetableItem) =>
            timetableItem.weekNumber == widget.weekNumber &&
            timetableItem.dayNumber == widget.dayOfWeekNumber)
        .toList();

    timetableItemUpdates =
        widget.timetableItemUpdates.where((timetableItemUpdate) {
      DateTime dateTime =
          DateTime.parse(timetableItemUpdate.date.replaceAll('/', '-'));

      if (widget.dateTime.asDate().isAtSameMomentAs(dateTime.asDate())) {
        return true;
      }
      return false;
    }).toList();

    List<UpdatableTimetableItem> updatableTimetableItems = timetableItems
        .expand(
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
            .map((timetableItemUpdate) => createNewUpdatableItem(
                timetableItemUpdate: timetableItemUpdate))
            .toList();

    updatableTimetableItems.addAll(newUpdatableTimetableItems);

    updatableTimetableItems = updatableTimetableItems
        .where((updatableTimetableItem) => !updatableTimetableItem.isEmpty)
        .toList();

    updatableTimetableItems.sort((a, b) => a.compareTo(b));

    return updatableTimetableItems;
  }

  List<UpdatableTimetableItem> createUpdatableItem(
      {required List<TimetableItemUpdate> timetableItemUpdates,
      required TimetableItem timetableItem}) {
    TimetableItemUpdate? itemUpdate;

    if (timetableItemUpdates.isNotEmpty) {
      List<TimetableItemUpdate> updates =
          timetableItemUpdates.where((timetableUpdate) {
        String updateItemTime = timetableUpdate.time;
        String activityStartTime = timetableItem.activity.time.start;

        return updateItemTime == activityStartTime;
      }).toList();

      if (updates.length == 1) {
        itemUpdate = updates.first;
      } else if (updates.length > 1) {
        List<TimetableItemUpdate> updatesWithItem =
            updates.where((update) => update.timetableItem != null).toList();
        if (updatesWithItem.isNotEmpty) {
          if (updatesWithItem.length == 2 &&
              updatesWithItem[0].timetableItem!.activity.time.start !=
                  updatesWithItem[1].timetableItem!.activity.time.start) {
            return [
              UpdatableTimetableItem(
                timetableItem: timetableItem,
                timetableItemUpdate: updatesWithItem[0],
              ),
              UpdatableTimetableItem(
                timetableItem: null,
                timetableItemUpdate: updatesWithItem[1],
              )
            ];
          } else {
            itemUpdate = updatesWithItem.first;
          }
        } else {
          itemUpdate = updates.first;
        }
      }
    }

    return [
      UpdatableTimetableItem(
          timetableItem: timetableItem, timetableItemUpdate: itemUpdate)
    ];
  }

  UpdatableTimetableItem createNewUpdatableItem({
    TimetableItemUpdate? timetableItemUpdate,
  }) {
    return UpdatableTimetableItem(
      timetableItem: null,
      timetableItemUpdate: timetableItemUpdate,
    );
  }
}
