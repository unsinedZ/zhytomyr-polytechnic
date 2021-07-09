import 'dart:convert';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/firestore/v1.dart';

import 'package:timetable/timetable.dart';

class GroupTimetableFirestoreRepository //implements TimetableRepository
{
  final AuthClient client;

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
    RunQueryRequest runQueryRequest = RunQueryRequest();
    StructuredQuery structuredQuery = StructuredQuery();
    Filter filter = Filter();
    FieldFilter fieldFilter = FieldFilter();
    FieldReference fieldReference = FieldReference();
    fieldReference.fieldPath = 'phoneNumber';
    Value value = Value();
    value.stringValue = '+38 (0412) 24-14-22';

    fieldFilter.value = value;
    fieldFilter.field = fieldReference;
    fieldFilter.op = 'EQUAL';

    filter.fieldFilter = fieldFilter;

    structuredQuery.where = filter;

    CollectionSelector collectionSelector = CollectionSelector();
    collectionSelector.collectionId = 'contacts';
    collectionSelector.allDescendants = true;

    structuredQuery.from = [collectionSelector];

    runQueryRequest.structuredQuery = structuredQuery;

    RunQueryResponse runQueryResponse =  await firestoreApi.projects.databases.documents.runQuery(
      runQueryRequest,
      'projects/zhytomyr-politechnic-dev/databases/(default)/documents',
    );

    runQueryResponse.document!.toJson().forEach((key, value) {
      print(key);
      print(value);
    });

    // .documents.get(
    // 'projects/zhytomyr-politechnic-dev/databases/(default)/documents/contacts');
    // ListDocumentsResponse document =
    //     await firestoreApi.projects.databases.documents.list(
    //         'projects/zhytomyr-politechnic-dev/databases/(default)/documents',
    //         'contacts');
    // document.toJson().forEach((key, value) {
    //   print(key);
    //   print(value);
    // });
  }
}
