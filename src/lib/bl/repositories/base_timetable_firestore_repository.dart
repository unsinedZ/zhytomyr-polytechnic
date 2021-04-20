import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timetable/timetable.dart';

class BaseTimetableFirestoreRepository {
  Future<Timetable> loadTimetable() async {
    Timetable timetable;

    timetable = Timetable.fromJson(
        (await FirebaseFirestore.instance.collection('timetable').get())
            .docs
            .map((doc) => doc.data()!)
            .first);

    return timetable;
  }

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


