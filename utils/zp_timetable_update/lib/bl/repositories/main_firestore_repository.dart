// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:timetable/timetable.dart';
//
// class MainFirestoreRepository implements GroupRepository, TutorRepository {
//   Future<List<Group>> getAllGroups() async {
//     List<Map<String, dynamic>>? expirableGroupsJson;
//
//     if (expirableGroupsJson == null) {
//       expirableGroupsJson =
//           (await FirebaseFirestore.instance.collection('group').get())
//               .docs
//               .map((doc) => doc.data())
//               .toList();
//     }
//
//     return expirableGroupsJson
//         .map(
//           (groupJson) => Group.fromJson(groupJson),
//         )
//         .toList();
//   }
//
//   @override
//   Future<Group> getGroupById(int groupId) async {
//     return (await this.getAllGroups())
//         .firstWhere((group) => group.id == groupId);
//   }
//
//   Future<void> changeUserInfo(
//       String userId, String groupId, String subgroupId) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//
//     if (sharedPreferences.containsKey('timetable.group.my')) {
//       sharedPreferences.remove('timetable.group.my');
//     }
//
//     return (await FirebaseFirestore.instance
//             .collection("users")
//             .where(
//               "userId",
//               isEqualTo: userId,
//             )
//             .get())
//         .docs
//         .first
//         .reference
//         .update(
//       {
//         'groupId': groupId,
//         'subgroupId': subgroupId,
//       },
//     );
//   }
//
//
//   @override
//   Future<Tutor?> getTutorById(int teacherId) async {
//     List<Tutor> tutors = (await FirebaseFirestore.instance
//             .collection("tutors")
//             .where("id", isEqualTo: teacherId)
//             .get())
//         .docs
//         .map((doc) => Tutor.fromJson(doc.data()))
//         .toList();
//
//     if (tutors.isNotEmpty) {
//       return tutors.first;
//     } else {
//       return null;
//     }
//   }
// }
