import 'dart:async';

import 'package:faculty_list/src/bl/models/faculty.dart';
import 'package:faculty_list/src/bl/astractions/faculty_repository.dart';

class FacultyListBloc {
  final FacultyRepository facultyRepository;
  final StreamSink<String> errorSink;

  StreamController<List<Faculty>> _facultiesListController = StreamController();

  FacultyListBloc({
    required this.facultyRepository,
    required this.errorSink,
  });

  Stream<List<Faculty>> get faculties => _facultiesListController.stream;

  Future<void> loadList() {
    try {
      return facultyRepository
          .getFaculties()
          .map(
            (facultyList) => _facultiesListController.add(facultyList),
          )
          .toList();
    } catch (err) {
      errorSink.add(err.toString());
      return Future.value(null);
    }
  }

  void dispose() {
    _facultiesListController.close();
  }
}
