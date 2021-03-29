import 'dart:async';

import 'package:faculty_list_abstractions/faculty_list_abstractions.dart';

class FacultyListBloc {
  final FacultyRepository facultyRepository;

  StreamController<List<Faculty>> _facultiesListController = StreamController();

  FacultyListBloc({required this.facultyRepository});

  Stream<List<Faculty>> get faculties => _facultiesListController.stream;

  Future<void> loadList() => facultyRepository
      .getList()
      .map(
        _facultiesListController.add,
      )
      .toList();

  void dispose() {
    _facultiesListController.close();
  }
}
