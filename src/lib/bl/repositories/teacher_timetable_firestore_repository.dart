import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timetable/timetable.dart';

import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/base_timetable_firestore_repository.dart';

class TeacherTimetableFirestoreRepository
    extends BaseTimetableFirestoreRepository implements TimetableRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  TeacherTimetableFirestoreRepository({required this.firebaseFirestoreInstance})
      : super(firebaseFirestoreInstance: firebaseFirestoreInstance);

  @override
  Future<Timetable> loadTimetableByKey(String key, [String? userGroupId]) async {
    Expirable<Map<String, dynamic>>? expirableTimetableJson;

    Timetable timetable = Timetable.fromJson(
        (await firebaseFirestoreInstance.collection('timetable').get())
            .docs
            .map((doc) => doc.data())
            .first);

    List<TimetableItem> items = timetable.items
        .where((element) => element.activity.tutor.id == key)
        .toList();

    expirableTimetableJson = Expirable<Map<String, dynamic>>(
      duration: Duration(days: 30),
      data: Timetable(
        weekDetermination: timetable.weekDetermination,
        items: items,
        expiresAt: timetable.expiresAt,
      ).toJson(),
    );

    return Timetable.fromJson(expirableTimetableJson.data);
  }
}
