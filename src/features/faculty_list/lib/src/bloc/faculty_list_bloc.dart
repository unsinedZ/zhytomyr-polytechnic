import 'dart:async';

import 'package:faculty_list/src/models/faculty.dart';
import 'package:faculty_list/src/repositories/faculty_repository.dart';

class FacultyListBloc {
  final FacultyRepository facultyRepository;

  StreamController<List<Faculty>> _facultiesListController = StreamController();

  FacultyListBloc({required this.facultyRepository});

  Stream<List<Faculty>> get faculties => _facultiesListController.stream;

  Future<void> loadList() => facultyRepository
      .getList()
      .map((facultyList) =>
        _facultiesListController.add(facultyList),
      )
      .toList();

  void dispose() {
    _facultiesListController.close();
  }
}
