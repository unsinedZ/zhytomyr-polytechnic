import 'dart:async';

import 'package:faculty_list/src/bl/models/faculty.dart';

abstract class FacultyRepository {
  Stream<List<Faculty>> getList();
}