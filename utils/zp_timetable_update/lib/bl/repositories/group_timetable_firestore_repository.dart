import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/firestore/v1.dart';

import 'package:timetable/timetable.dart';

class GroupTimetableFirestoreRepository
    //implements TimetableRepository
{
  final Client client;

  GroupTimetableFirestoreRepository({
    required this.client,
  });

  // @override
  // Future<Timetable> loadTimetableByReferenceId(int id,
  //     [String? userGroupId]) async {
  //
  //   Timetable? timetable;
  //   TimetableData timetableData;
  //
  //   timetableData = TimetableData.fromJson((await firebaseFirestoreInstance
  //           .collection('timetable')
  //           .where("enabled", isEqualTo: 1)
  //           .get())
  //       .docs
  //       .map((doc) => doc.data())
  //       .first);
  //
  //   if (timetable == null) {
  //     List<dynamic> itemsJson = (await firebaseFirestoreInstance
  //             .collection('timetable_item_group')
  //             .where("key", isEqualTo: 'group/' + id.toString())
  //             .get())
  //         .docs
  //         .map((doc) => doc.data())
  //         .first['items'];
  //
  //     timetable = Timetable(
  //       timetableData: timetableData,
  //       items: itemsJson
  //           .map((itemJson) => TimetableItem.fromJson(itemJson))
  //           .toList(),
  //     );
  //   }
  //
  //   return timetable;
  // }
  //
  // Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id) async {
  //   return firebaseFirestoreInstance
  //       .collection('timetable_item_update')
  //       .where('key', isEqualTo: 'group/' + id.toString())
  //       .get()
  //       .then(
  //         (timetableItemUpdateListJson) => timetableItemUpdateListJson.docs
  //             .map(
  //               (timetableItemUpdateJson) => TimetableItemUpdate.fromJson(
  //                   timetableItemUpdateJson.data()),
  //             )
  //             .toList(),
  //       );
  // }

  void test() async {
    FirestoreApi firestoreApi = FirestoreApi(client);
    ProjectsResource projectsResource = firestoreApi.projects;
    Document document = await firestoreApi.projects.databases.documents.get('contacts');
    document.fields!.forEach((key, value) {
      print(key);
      print(value);
    });
  }
}
