import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableLoaderMock extends Mock implements TimetableRepository {}

void main() {
  test('TimetableBloc.loadTimetable work correctly', () async {
    TimetableLoaderMock timetableLoaderMock = TimetableLoaderMock();

    TimetableBloc groupSelectionBloc =
        TimetableBloc(timetableRepository: timetableLoaderMock, errorSink: StreamController<String>().sink);

    when(timetableLoaderMock.loadTimetable()).thenAnswer((_) => Future.value(
        Timetable(weekDetermination: WeekDetermination.Even, items: [])));

    List<Timetable?> results = <Timetable?>[];

    groupSelectionBloc.timetable.listen((groups) => results.add(groups));
    groupSelectionBloc.loadTimetable();

    await Future.delayed(const Duration());

    expect(results[0], null);
    expect(results[1]!.weekDetermination, WeekDetermination.Even);
    expect(results[1]!.items!.length, 0);
  });
}
