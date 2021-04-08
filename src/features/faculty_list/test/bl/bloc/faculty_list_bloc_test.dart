import 'dart:async';

import 'package:faculty_list/src/bl/bloc/faculty_list_bloc.dart';
import 'package:faculty_list/src/bl/models/faculty.dart';
import 'package:faculty_list/src/bl/astractions/faculty_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FacultyRepositoryMock extends FacultyRepository {
  @override
  Stream<List<Faculty>> getFaculties() => Stream.value([
          Faculty(id: 1, name: "name", imageUrl: "imageUrl"),
          Faculty(id: 2, name: "name", imageUrl: "imageUrl")
        ]);
}

void main() {
  test("FacultyListBloc work correctly", () async {
    List<Faculty> result = [];
    FacultyRepositoryMock facultyRepositoryMock = FacultyRepositoryMock();

    FacultyListBloc facultyListBloc =
        FacultyListBloc(facultyRepository: facultyRepositoryMock, errorSink: StreamController<String>().sink);

    facultyListBloc.faculties.listen((facultyList) => result += facultyList);
 
    facultyListBloc.loadList();

    await Future.delayed(const Duration());

    expect(result.length, 2);
    expect(result[0].id, 1);
    expect(result[1].id, 2);
  });
}
