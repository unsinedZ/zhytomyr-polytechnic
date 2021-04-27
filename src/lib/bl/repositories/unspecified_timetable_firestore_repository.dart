import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/base_timetable_firestore_repository.dart';

class UnspecifiedTimetableFirestoreRepository extends BaseTimetableFirestoreRepository implements TimetableRepository {
  @override
  Future<Timetable> loadTimetableByReferenceId(String referenceId) {
    throw UnimplementedError('Wrong parameters');
  }

  @override
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() {
    throw UnimplementedError('Wrong parameters');
  }

}
