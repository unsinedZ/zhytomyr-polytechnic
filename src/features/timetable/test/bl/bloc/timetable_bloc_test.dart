import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'package:timetable/src/bl/abstractions/timetable_loader.dart';
import 'package:timetable/src/bl/bloc/timetable_bloc.dart';
import 'package:timetable/src/bl/models/models.dart';

class TimetableLoaderMock extends Mock implements TimetableLoader {
  @override
  Future<Timetable> loadTimetable(WeekDetermination? weekDetermination) =>
      super.noSuchMethod(Invocation.method(#loadTimetable, [weekDetermination]),
          returnValue: Future.value(
              Timetable(weekDetermination: WeekDetermination.Odd)));
}

void main() {
  test('TimetableBloc.loadTimetable work correctly', () async {
    TimetableLoaderMock timetableLoaderMock = TimetableLoaderMock();

    TimetableBloc groupSelectionBloc =
        TimetableBloc(timetableLoader: timetableLoaderMock, errorSink: StreamController<String>().sink);

    when(timetableLoaderMock.loadTimetable(any)).thenAnswer((_) => Future.value(
        Timetable(weekDetermination: WeekDetermination.Even, items: [])));

    List<Timetable?> results = <Timetable?>[];

    groupSelectionBloc.timetable.listen((groups) => results.add(groups));
    groupSelectionBloc.loadTimetable(WeekDetermination.Even);

    await Future.delayed(const Duration());

    expect(results[0], null);
    expect(results[1]!.weekDetermination, WeekDetermination.Even);
    expect(results[1]!.items!.length, 0);
  });
}
