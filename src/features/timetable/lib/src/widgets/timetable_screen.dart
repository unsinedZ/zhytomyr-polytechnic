import 'dart:async';

import 'package:flutter/material.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/widgets/components/timetable_tab.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/abstractions/timetable_loader.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final TimetableLoader timetableLoader;
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

  late TimetableBloc timetableBloc;
  late String id;
  late TimetableType timetableType;

  @override
  void initState() {
    timetableBloc = TimetableBloc(
      timetableLoader: widget.timetableLoader,
      errorSink: widget.errorSink,
    );

    timetableBloc.loadTimetable(WeekDetermination.Odd);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    id = (ModalRoute.of(context)!.settings.arguments as List<dynamic>)[0];

    if ((ModalRoute.of(context)!.settings.arguments as List<dynamic>)[1] ==
        'group') {
      timetableType = TimetableType.Group;
    } else {
      timetableType = TimetableType.Teacher;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 6,
      child: StreamBuilder<Timetable?>(
        stream: timetableBloc.timetable,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  indicatorColor: Colors.amberAccent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xc3ffffff),
                  tabs: [
                    Tab(
                      text: widget.textLocalizer.localize('Mon'),
                    ),
                    Tab(
                      text: widget.textLocalizer.localize('Tue'),
                    ),
                    Tab(
                      text: widget.textLocalizer.localize('Wed'),
                    ),
                    Tab(
                      text: widget.textLocalizer.localize('Thu'),
                    ),
                    Tab(
                      text: widget.textLocalizer.localize('Fri'),
                    ),
                    Tab(
                      text: widget.textLocalizer.localize('Sat'),
                    ),
                  ],
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
              body: TabBarView(
                children: [
                  TimetableTab(
                    timetable: snapshot.data!,
                    weekNumber: 1,
                    dateTime: DateTime.now().add(Duration(days: -initialIndex)),
                    id: id,
                    timetableType: timetableType,
                  ),
                  TimetableTab(
                    timetable: snapshot.data!,
                    weekNumber: 2,
                    dateTime:
                        DateTime.now().add(Duration(days: -initialIndex + 1)),
                    id: id,
                    timetableType: timetableType,
                  ),
                  TimetableTab(
                    timetable: snapshot.data!,
                    weekNumber: 3,
                    dateTime:
                        DateTime.now().add(Duration(days: -initialIndex + 2)),
                    id: id,
                    timetableType: timetableType,
                  ),
                  TimetableTab(
                    timetable: snapshot.data!,
                    weekNumber: 4,
                    dateTime:
                        DateTime.now().add(Duration(days: -initialIndex + 3)),
                    id: id,
                    timetableType: timetableType,
                  ),
                  TimetableTab(
                    timetable: snapshot.data!,
                    weekNumber: 5,
                    dateTime:
                        DateTime.now().add(Duration(days: -initialIndex + 4)),
                    id: id,
                    timetableType: timetableType,
                  ),
                  TimetableTab(
                    timetable: snapshot.data!,
                    weekNumber: 6,
                    dateTime:
                        DateTime.now().add(Duration(days: -initialIndex + 5)),
                    id: id,
                    timetableType: timetableType,
                  ),
                ],
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
