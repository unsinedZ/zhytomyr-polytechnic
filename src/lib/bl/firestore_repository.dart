import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:faculty_list/faculty_list.dart';

import 'package:group_selection/group_selection.dart';

import 'package:timetable/timetable.dart' as Timetable;

import 'package:user_sync/user_sync.dart' as UserSync;

class FirestoreRepository
    implements
        FacultyRepository,
        GroupsLoader,
        Timetable.TimetableRepository,
        UserSync.UserRepository {
  @override
  Stream<List<Faculty>> getFaculties() =>
      FirebaseFirestore.instance.collection('faculty').get().asStream().map(
            (facultyListJson) => facultyListJson.docs
                .map(
                  (facultyJson) => Faculty.fromJson(facultyJson.data()!),
                )
                .toList(),
          );

  @override
  Future<List<Group>> getGroups(int course, String facultyId) async {
    return FirebaseFirestore.instance.collection('group').get().then(
        (groupListJson) => groupListJson.docs
            .map(
              (groupJson) => Group.fromJson(groupJson.data()!),
            )
            .where(
                (group) => group.year == course && group.facultyId == facultyId)
            .toList());
  }

  @override
  Future<Timetable.Timetable> loadTimetable() async {
    return FirebaseFirestore.instance.collection('timetable').get().then(
        (timetablesListJson) => timetablesListJson.docs
            .map((timetableJson) =>
                Timetable.Timetable.fromJson(timetableJson.data()!))
            .first);
  }

  @override
  Future<Timetable.Group> getGroupById(String groupId) async {
    return FirebaseFirestore.instance
        .collection('group')
        .get()
        .then((groupListJson) => groupListJson.docs
            .map(
              (groupJson) => Timetable.Group.fromJson(groupJson.data()!),
            )
            .firstWhere((group) => group.id == groupId));
  }

  @override
  Future<Map<String, dynamic>?> changeUserInfo(
          String userId, Map<String, dynamic> data) =>
      FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("userId", isEqualTo: userId)
            .get();
        transaction.update(snapshot.docs.first.reference, data);
        return (await FirebaseFirestore.instance
            .collection("users")
            .where("userId", isEqualTo: userId)
            .get()).docs.first.data();
      });

  @override
  Future<Map<String, dynamic>?> getUserInfo(String userId) async =>
      (await FirebaseFirestore.instance
          .collection("users")
          .where("userId", isEqualTo: userId)
          .get()).docs.first.data();
}
