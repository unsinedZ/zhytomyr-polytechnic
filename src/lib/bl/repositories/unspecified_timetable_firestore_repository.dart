import 'package:timetable/timetable.dart';

class UnspecifiedTimetableFirestoreRepository implements TimetableRepository {
  @override
  Future<Timetable> loadTimetableByReferenceId(String referenceId) {
    throw UnimplementedError('Wrong parameters');
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() {
    throw UnimplementedError('Wrong parameters');
  }
}
