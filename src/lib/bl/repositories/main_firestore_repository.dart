import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:faculty_list/faculty_list.dart';
import 'package:group_selection/group_selection.dart';
import 'package:contacts/contacts.dart';
import 'package:timetable/timetable.dart' as Timetable;
import 'package:user_sync/user_sync.dart';
import 'package:update_check/update_check.dart';

import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';

class FirestoreRepository
    implements
        FacultyRepository,
        GroupsRepository,
        Timetable.GroupRepository,
        ContactsRepository,
        UserRepository,
        Timetable.TutorRepository,
        VersionsRepository {
  @override
  Stream<List<Faculty>> getFaculties() =>
      FirebaseFirestore.instance.collection('faculty').get().asStream().map(
            (facultyListJson) => facultyListJson.docs
                .map(
                  (facultyJson) => Faculty.fromJson(facultyJson.data()),
                )
                .toList(),
          );

  Future<List<Group>> getAllGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Expirable<List<Map<String, dynamic>>>? expirableGroupsJson;

    if (prefs.containsKey('groups')) {
      Map<String, dynamic> json = jsonDecode(prefs.getString('groups')!);
      json['data'] = (json['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      expirableGroupsJson =
          (Expirable<List<Map<String, dynamic>>>.fromJson(json));

      if (expirableGroupsJson.expireAt.isBefore(DateTime.now())) {
        expirableGroupsJson = null;
      }
    }

    if (expirableGroupsJson == null) {
      expirableGroupsJson = Expirable<List<Map<String, dynamic>>>(
          duration: Duration(days: 30),
          data: (await FirebaseFirestore.instance.collection('group').get())
              .docs
              .map((doc) => doc.data())
              .toList());

      prefs.setString('groups', jsonEncode(expirableGroupsJson));
    }

    List<Group> groups = expirableGroupsJson.data
        .map(
          (groupJson) => Group.fromJson(groupJson),
        )
        .toList();

    return groups;
  }

  @override
  Future<List<Group>> getGroups(String year, int facultyId) async {
    List<Group> groups = (await this.getAllGroups())
        .where((group) => group.year == year && group.facultyId == facultyId)
        .toList();

    return groups;
  }

  @override
  Future<Timetable.Group> getGroupById(int groupId) async {
    Timetable.Group group = (await this.getAllGroups())
        .map((group) => Timetable.Group.fromObject(group))
        .firstWhere((group) => group.id == groupId);

    return group;
  }

  @override
  Future<ContactsData> loadContactsData() async {
    ContactsData contactsData = ContactsData.fromJson(
        (await FirebaseFirestore.instance.collection('contacts').get())
            .docs
            .first
            .data());

    return contactsData;
  }

  Future<void> changeUserInfo(
      String userId, String groupId, String subgroupId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey('timetable.group.my')) {
      sharedPreferences.remove('timetable.group.my');
    }

    return (await FirebaseFirestore.instance
            .collection("users")
            .where(
              "userId",
              isEqualTo: userId,
            )
            .get())
        .docs
        .first
        .reference
        .update(
      {
        'groupId': groupId,
        'subgroupId': subgroupId,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    final docs = (await FirebaseFirestore.instance
            .collection("users")
            .where("userId", isEqualTo: userId)
            .get())
        .docs;

    if (docs.isNotEmpty) {
      return docs.first.data();
    } else {
      return {"userId": userId, 'groupId': '', 'subgroupId': ''};
    }
  }

  @override
  Future<Timetable.Tutor?> getTutorById(int teacherId) async {
    List<Timetable.Tutor> tutors = (await FirebaseFirestore.instance
            .collection("tutors")
            .where("id", isEqualTo: teacherId)
            .get())
        .docs
        .map((doc) => Timetable.Tutor.fromJson(doc.data()))
        .toList();

    if (tutors.isNotEmpty) {
      return tutors.first;
    }
    return null;
  }

  @override
  Future<Version> loadLastVersion(String platformOS) async {
    List<Version> versions = (await FirebaseFirestore.instance
            .collection("versions")
            .where("os", isEqualTo: platformOS)
            .get())
        .docs
        .map((doc) => Version.fromJson(doc.data()))
        .toList();

    if (versions.isNotEmpty) {
      return versions.first;
    }

    throw ArgumentError('No data in database');
  }
}
