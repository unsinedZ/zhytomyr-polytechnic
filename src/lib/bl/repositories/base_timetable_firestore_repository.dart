import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timetable/timetable.dart';

class BaseTimetableFirestoreRepository {
  Future<List<TimetableItemUpdate>> getTimetableItemUpdates() {
    return FirebaseFirestore.instance
        .collection('timetable_item_update')
        .get()
        .then((timetableItemUpdateListJson) => timetableItemUpdateListJson.docs
        .map(
          (timetableItemUpdateJson) =>
          TimetableItemUpdate.fromJson(timetableItemUpdateJson.data()!),
    )
        .toList());
  }
}


