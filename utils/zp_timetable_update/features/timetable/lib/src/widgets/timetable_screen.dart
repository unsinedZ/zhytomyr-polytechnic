import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:intl/intl.dart';

import 'package:rxdart/rxdart.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/widgets/components/components.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/abstractions/tutor_repository.dart';
import 'package:timetable/src/bl/models/models.dart';
import 'package:timetable/src/widgets/components/filters_bottom_sheet.dart';
import 'package:timetable/src/widgets/components/timetable_tab_shimmer.dart';
import 'package:timetable/timetable.dart';

class TimetableScreen extends StatefulWidget {
  final ITextLocalizer textLocalizer;
  final TimetableRepositoryFactory timetableRepositoryFactory;

  // final GroupRepository groupRepository;
  final TutorRepository tutorRepository;
  final StreamSink<String> errorSink;

  TimetableScreen({
    required this.textLocalizer,
    required this.timetableRepositoryFactory,
    // required this.groupRepository,
    required this.tutorRepository,
    required this.errorSink,
  });

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<String> _weekDaysNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  DateTime indexDayDateTime = DateTime.now();
  int initialIndex = (DateTime.now().weekday - 1) % 6;
  bool isWeekChanged = false;
  bool isNextDay = false;

  late TimetableBloc timetableBloc;
  late TimetableType timetableType;
  late int weekNumber;
  late int id;
  late AuthClient client;
  late Stream<List<dynamic>> dataStream;

  StreamSubscription? groupStreamSubscription;
  StreamSubscription? clientStreamSubscription;
  int? subgroupId;
  Group? group;
  Tutor? tutor;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  String get title => timetableType == TimetableType.Tutor
      ? (tutor == null ? '' : tutor!.name)
      : '';

  @override
  void initState() {
    if (indexDayDateTime.hour >= 18) {
      isNextDay = true;
      initialIndex = (initialIndex + 1) % 6;
      indexDayDateTime = indexDayDateTime.add(Duration(days: 1));
    }

    weekNumber = _calculateWeekNumber();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;

    id = arguments['id'];
    timetableType = timetableTypeFromString(arguments['type'] as String);
    client = arguments['client'];

    timetableBloc = TimetableBloc(
      timetableRepository: widget.timetableRepositoryFactory
          .getTimetableRepository(timetableType, client),
      errorSink: widget.errorSink,
      //groupRepository: widget.groupRepository,
      tutorRepository: widget.tutorRepository,
    );

    timetableBloc.loadTimetableItemUpdates(id);

    timetableBloc.loadTimetable(id);

    if (timetableType == TimetableType.Tutor) {
      timetableBloc.loadTutor(id, client);
      timetableBloc.tutor.listen((tutor) {
        setState(() {
          this.tutor = tutor;
        });
      });
    }

    dataStream = Rx.combineLatest2(
      timetableBloc.timetable,
      timetableBloc.timetableItemUpdates,
      (a, b) => <dynamic>[a, b],
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.amberAccent,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xc3ffffff),
            tabs: _weekDaysNames
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
            title,
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
                      currentWeekNumber: weekNumber,
                      timetableType: timetableType,
                      group: group,
                      currentSubgroupId: subgroupId,
                      textLocalizer: widget.textLocalizer,
                    ),
                  );
                },
          child: Icon(Icons.filter_alt_outlined),
        ),
        body: StreamBuilder<List<dynamic>>(
          stream: dataStream,
          builder: (context, snapshot) {
            if (_isSnapshotHasData(snapshot)) {
              Timetable timetable = snapshot.data![0];
              List<TimetableItemUpdate> timetableItemUpdates =
                  snapshot.data![1];

              if ((weekNumber.isEven &&
                      timetable.timetableData.weekDetermination ==
                          WeekDetermination.Even) ||
                  (weekNumber.isOdd &&
                      timetable.timetableData.weekDetermination ==
                          WeekDetermination.Odd)) {
                weekNumber = 1;
              } else {
                weekNumber = 2;
              }

              return TabBarView(
                children: _weekDaysNames
                    .asMap()
                    .keys
                    .map<Widget>(
                      (index) => TimetableTab(
                        textLocalizer: widget.textLocalizer,
                        timetable: timetable,
                        timetableItemUpdates: timetableItemUpdates,
                        weekNumber: weekNumber,
                        dayOfWeekNumber: index + 1,
                        dateTime: indexDayDateTime.add(Duration(
                            days: -initialIndex +
                                index +
                                (isWeekChanged ? 7 : 0))),
                        id: id,
                        subgroupId: subgroupId,
                        timetableType: timetableType,
                        isTomorrow: initialIndex == index &&
                                isNextDay == true &&
                                isWeekChanged == false
                            ? true
                            : false,
                      ),
                    )
                    .toList(),
              );
            } else
              return TimetableTabShimmer();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupStreamSubscription?.cancel();
    clientStreamSubscription?.cancel();

    super.dispose();
  }
}

enum TimetableType { Tutor, Unspecified }

TimetableType timetableTypeFromString(String value) =>
    TimetableType.values.firstWhere(
        (e) =>
            e.toString().split(".").last.toLowerCase() == value.toLowerCase(),
        orElse: () => TimetableType.Unspecified);

bool _isSnapshotHasData(AsyncSnapshot<List<dynamic>> snapshot) {
  if (snapshot.hasData &&
      snapshot.data != null &&
      snapshot.data![0] != null &&
      snapshot.data![1] != null) {
    return true;
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
