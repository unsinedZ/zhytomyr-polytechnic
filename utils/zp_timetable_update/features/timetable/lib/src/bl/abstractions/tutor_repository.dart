import 'package:googleapis_auth/auth_io.dart';

import 'package:timetable/src/bl/models/models.dart';

abstract class TutorRepository {
  Future<Tutor?> getTutorById();
}