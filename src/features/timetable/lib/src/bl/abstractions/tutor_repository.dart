import 'package:timetable/src/bl/models/models.dart';

abstract class TutorRepository {
  Future<Tutor?> getTutorById(String teacherId);
}