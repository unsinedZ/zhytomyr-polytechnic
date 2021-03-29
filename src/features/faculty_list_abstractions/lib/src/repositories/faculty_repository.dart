import 'dart:async';

import 'package:faculty_list_abstractions/src/models/faculty.dart';

abstract class FacultyRepository {
  Stream<List<Faculty>> getList();
}