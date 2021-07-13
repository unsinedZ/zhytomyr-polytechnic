// import 'dart:convert';
//
// import 'package:authorization_bloc/authorization_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:googleapis/firestore/v1.dart';
//
// import 'package:timetable/timetable.dart';
//
// import 'package:zp_timetable_update/bl/extensions/firestore_run_query_fixed_extension.dart';
// import 'package:zp_timetable_update/bl/models/expireble.dart';
//
// class GroupTimetableFirestoreRepository implements TimetableRepository {
//   final AuthClient client;
//   final Future<SharedPreferences> sharedPreferences;
//
//   GroupTimetableFirestoreRepository({
//     required this.client,
//     required this.sharedPreferences,
//   });
//
//   @override
//   Future<Timetable> loadTimetableByReferenceId(int id,
//       [String? userGroupId]) async {
//     final SharedPreferences prefs = await sharedPreferences;
//
//     Timetable? timetable;
//     TimetableData timetableData;
//
//     timetableData = await runQuery(
//             fieldPath: 'enabled',
//             fieldValue: '1',
//             collectionId: 'timetables',
//             valueType: ValueType.Int)
//         .then(
//       (docs) => TimetableData.fromJson(docs.first.toJson()),
//     );
//
//     if (prefs.containsKey('timetable.teacher') &&
//         userGroupId == id.toString() &&
//         timetableData.expiredAt.isAfter(DateTime.now())) {
//       Map<String, dynamic> json =
//           jsonDecode(prefs.getString('timetable.group.my')!);
//       json['data'] = (json['data'] as Map<String, dynamic>);
//
//       Expirable<Map<String, dynamic>> expirableTimetableJson =
//           Expirable<Map<String, dynamic>>.fromJson(json);
//
//       if (expirableTimetableJson.expireAt.isAfter(DateTime.now())) {
//         timetable = Timetable.fromJson(expirableTimetableJson.data);
//         if (timetable.timetableData.lastModified !=
//             timetableData.lastModified) {
//           timetable = null;
//         }
//       }
//     }
//
//     if (timetable == null) {
//       timetable = await runQuery(
//               fieldPath: 'key',
//               fieldValue: 'tutor/' + id.toString(),
//               collectionId: 'timetable_items_tutor',
//               valueType: ValueType.Int)
//           .then(
//         (docs) => Timetable(
//             timetableData: timetableData,
//             items: (docs.first.toJson()['items'] as List<dynamic>)
//                 .map((itemJson) => TimetableItem.fromJson(itemJson))
//                 .toList()),
//       );
//       // List<dynamic> itemsJson = (await firebaseFirestoreInstance
//       //         .collection('timetable_items_group')
//       //         .where("key", isEqualTo: 'group/' + id.toString())
//       //         .get())
//       //     .docs
//       //     .map((doc) => doc.data())
//       //     .first['items'];
//       //
//       // timetable = Timetable(
//       //   timetableData: timetableData,
//       //   items: itemsJson
//       //       .map((itemJson) => TimetableItem.fromJson(itemJson))
//       //       .toList(),
//       // );
//
//       if (userGroupId == id.toString()) {
//         Expirable<Map<String, dynamic>> expirableTimetableJson =
//             Expirable<Map<String, dynamic>>(
//           duration: Duration(days: 30),
//           data: timetable!.toJson(),
//         );
//
//         prefs.setString(
//           'timetable.teacher',
//           jsonEncode(expirableTimetableJson),
//         );
//       }
//     }
//
//     return timetable!;
//   }
//
//   @override
//   Future<List<TimetableItemUpdate>> getTimetableItemUpdates(int id) async {
//     List<TimetableItemUpdate> timetableUpdates = await runQuery(
//       fieldPath: 'key',
//       fieldValue: 'group/' + id.toString(),
//       collectionId: 'timetable_item_update',
//       valueType: ValueType.String,
//     ).then(
//       (docs) => docs
//           .map(
//             (timetableItemUpdateJson) =>
//                 TimetableItemUpdate.fromJson(timetableItemUpdateJson.toJson()),
//           )
//           .toList(),
//     );
//
//     return timetableUpdates;
//   }
//
//   Future<List<Document>> runQuery({
//     required String collectionId,
//     required String fieldPath,
//     required String fieldValue,
//     required ValueType valueType,
//   }) async {
//     FirestoreApi firestoreApi = FirestoreApi(client);
//     RunQueryRequest runQueryRequest = RunQueryRequest();
//     StructuredQuery structuredQuery = StructuredQuery();
//     Filter filter = Filter();
//     FieldFilter fieldFilter = FieldFilter();
//     FieldReference fieldReference = FieldReference();
//     fieldReference.fieldPath = fieldPath;
//     Value value = Value();
//     if (valueType == ValueType.String) {
//       value.stringValue = fieldValue;
//     } else if (valueType == ValueType.Int) {
//       value.integerValue = fieldValue;
//     }
//
//     fieldFilter.value = value;
//     fieldFilter.field = fieldReference;
//     fieldFilter.op = 'EQUAL';
//
//     filter.fieldFilter = fieldFilter;
//
//     structuredQuery.where = filter;
//
//     CollectionSelector collectionSelector = CollectionSelector();
//     collectionSelector.collectionId = collectionId;
//     collectionSelector.allDescendants = true;
//
//     structuredQuery.from = [collectionSelector];
//
//     runQueryRequest.structuredQuery = structuredQuery;
//
//     List<Document> documents =
//         await firestoreApi.projects.databases.documents.runQueryFixed(
//       runQueryRequest,
//       client: client,
//     );
//
//     // documents.forEach((doc) {
//     //   doc.fields!.forEach((key, value) {
//     //     print(key);
//     //     print(value);
//     //   });
//     // });
//     return documents;
//   }
// }
//
// enum ValueType { Int, String }
