import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/repositories/base_timetable_firestore_repository.dart';

class TeacherTimetableFirestoreRepository
    extends BaseTimetableFirestoreRepository implements TimetableRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  TeacherTimetableFirestoreRepository({required this.firebaseFirestoreInstance})
      : super(firebaseFirestoreInstance: firebaseFirestoreInstance);

  @override
  Future<Timetable> loadTimetableByReferenceId(int id, [String? userGroupId]) async {
    throw UnimplementedError('Not implemented');
  }
}
