import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty_list/src/models/faculty.dart';

class FacultyListBloc {
  StreamController<List<Faculty>> _facultiesListController = StreamController();

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
