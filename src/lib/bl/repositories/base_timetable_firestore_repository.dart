import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timetable/timetable.dart';

class BaseTimetableFirestoreRepository {
  final FirebaseFirestore firebaseFirestoreInstance;

  BaseTimetableFirestoreRepository({
    required this.firebaseFirestoreInstance,
  });

  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() {
    return firebaseFirestoreInstance
        .collection('timetable_item_update')
        .get()
        .then((timetableItemUpdateListJson) => timetableItemUpdateListJson.docs
        .map(
          (timetableItemUpdateJson) =>
          TimetableItemUpdate.fromJson(timetableItemUpdateJson.data()),
    )
        .toList());
  }
}


