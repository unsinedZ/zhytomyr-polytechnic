import 'dart:async';

abstract class FacultyRepository {
  Stream<List<Faculty>> getList();
}