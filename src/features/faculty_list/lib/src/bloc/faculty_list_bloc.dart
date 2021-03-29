import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty_list/src/models/faculty.dart';
import 'package:faculty_list/src/repositories/faculty_repository.dart';

class FacultyListBloc {
    final FacultyRepository facultyRepository;

  StreamController<List<Faculty>> _facultiesListController = StreamController();

FacultyListBloc({required this.facultyRepository});

  Stream<List<Faculty>> get faculties => _facultiesListController.stream;

  Future<void> loadList() async => await FirebaseFirestore.instance
      .collection('faculty')
      .get()
      .asStream()
      .map(
        (list) => _facultiesListController.add(
          list.docs
              .map((element) => Faculty.fromJson(element.data()!))
              .toList(),
        ),
      )
      .toList();

  void dispose() {
    _facultiesListController.close();
  }
}
