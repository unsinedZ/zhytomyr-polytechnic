import 'package:googleapis_auth/auth.dart';
import 'package:timetable/src/bl/abstractions/timetable_repository.dart';
import 'package:timetable/src/widgets/timetable_screen.dart';

abstract class TimetableRepositoryFactory {
  TimetableRepository getTimetableRepository(
    TimetableType timetableType,
    AuthClient client,
  );
}
