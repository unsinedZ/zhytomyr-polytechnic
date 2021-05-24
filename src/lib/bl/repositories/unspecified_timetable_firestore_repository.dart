import 'package:timetable/timetable.dart';

class UnspecifiedTimetableFirestoreRepository implements TimetableRepository {
  @override
  Future<Timetable> loadTimetableByKey(String referenceId, [String? userGroupId]) {
    throw UnimplementedError('Wrong parameters');
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() {
    throw UnimplementedError('Wrong parameters');
  }
}
