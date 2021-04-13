import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:rxdart/rxdart.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/widgets/components/timetable_tab.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/widgets/components/filters_bottom_sheet.dart';

class TimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final TimetableRepository timetableLoader;
  final StreamSink<String> errorSink;

  TimetableScreen({
    required this.textLocalizer,
    required this.timetableLoader,
    required this.errorSink,
  });

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  int initialIndex = (DateTime.now().weekday - 1) % 6;
  bool isWeekChanged = false;

  late TimetableBloc timetableBloc;
  late TimetableType timetableType;
  late int weekNumber;
  late String id;

  String? subgroupId;

  @override
  void initState() {
    timetableBloc = TimetableBloc(
      timetableRepository: widget.timetableLoader,
      errorSink: widget.errorSink,
    );

    timetableBloc.loadTimetable();

    weekNumber = _calculateWeekNumber();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Object? arguments = ModalRoute.of(context)!.settings.arguments;

    if ((arguments as List<dynamic>).length > 3) {
      TimetableFilters timetableFilters = arguments[3];
      weekNumber = timetableFilters.weekNumber;
      id = timetableFilters.id;
      subgroupId = timetableFilters.subgroupId;
      timetableType = timetableFilters.timetableType;
      initialIndex = timetableFilters.weekDayNumber - 1;
    } else {
      id = (arguments)[1];

      if ((arguments)[0] == 'group') {
        subgroupId = (arguments)[2];
        timetableType = TimetableType.Group;
      } else {
        timetableType = TimetableType.Teacher;
      }
    }

    if (timetableType == TimetableType.Group) {
      timetableBloc.loadGroup(id);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 6,
      child: StreamBuilder<List<dynamic>>(
        stream: Rx.combineLatest2(timetableBloc.timetable, timetableBloc.group,
            (a, b) => <dynamic>[a, b]),
        builder: (context, snapshot) {
          if (_isSnapshotHasData(snapshot, timetableType)) {
            Timetable timetable = snapshot.data![0];
            Group? group = snapshot.data![1];

            if ((weekNumber.isEven &&
                    timetable.weekDetermination == WeekDetermination.Even) ||
                (weekNumber.isOdd &&
                    timetable.weekDetermination == WeekDetermination.Odd)) {
              weekNumber = 1;
            } else {
              weekNumber = 2;
            }

            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: Colors.amberAccent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xc3ffffff),
                  tabs: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((weekDay) => Tab(
                            text: widget.textLocalizer.localize(weekDay),
                          ))
                      .toList(),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  widget.textLocalizer.localize('Timetable'),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => FiltersBottomSheet(
                      onCurrentWeekChanged: (int newWeekNumber) {
                        setState(() {
                          weekNumber = newWeekNumber;
                          isWeekChanged = !isWeekChanged;
                        });
                      },
                      onCurrentSubgroupChanged: (String newSubgroupId) {
                        setState(() {
                          subgroupId = newSubgroupId;
                        });
                      },
                      currentWeekNumber: weekNumber,
                      timetableType: timetableType,
                      group: group,
                      currentSubgroupId: subgroupId,
                      textLocalizer: widget.textLocalizer,
                    ),
                  );
                },
                child: Icon(Icons.settings),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: TabBarView(
                children: [0, 1, 2, 3, 4, 5]
                    .map<Widget>((index) => TimetableTab(
                          textLocalizer: widget.textLocalizer,
                          timetable: timetable,
                          weekNumber: weekNumber,
                          dayOfWeekNumber: index + 1,
                          dateTime: DateTime.now().add(Duration(
                              days: -initialIndex +
                                  index +
                                  (isWeekChanged ? 7 : 0))),
                          id: id,
                          subgroupId: subgroupId,
                          timetableType: timetableType,
                        ))
                    .toList(),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

enum TimetableType { Group, Teacher }

bool _isSnapshotHasData(
    AsyncSnapshot<List<dynamic>> snapshot, TimetableType timetableType) {
  if (snapshot.hasData && snapshot.data != null && snapshot.data![0] != null) {
    if (timetableType == TimetableType.Group && snapshot.data![1] != null) {
      return true;
    } else if (timetableType == TimetableType.Group) {
      return true;
    }
  }

  return false;
}

int _calculateWeekNumber() {
  final date = DateTime.now();

  int dayOfYear = int.parse(DateFormat("D").format(date));
  int weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();

  if (weekNumber < 1) {
    weekNumber = _numOfWeeks(date.year - 1);
  } else if (weekNumber > _numOfWeeks(date.year)) {
    weekNumber = 1;
  }

  return weekNumber;
}

int _numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}
