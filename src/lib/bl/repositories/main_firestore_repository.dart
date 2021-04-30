import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:faculty_list/faculty_list.dart';
import 'package:group_selection/group_selection.dart';
import 'package:contacts/contacts.dart';
import 'package:timetable/timetable.dart' as Timetable;
import 'package:user_sync/user_sync.dart';

import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';

class FirestoreRepository
    implements
        FacultyRepository,
        GroupsRepository,
        Timetable.GroupRepository,
        ContactsRepository,
        UserRepository {
  @override
  Stream<List<Faculty>> getFaculties() =>
      FirebaseFirestore.instance.collection('faculty').get().asStream().map(
            (facultyListJson) => facultyListJson.docs
                .map(
                  (facultyJson) => Faculty.fromJson(facultyJson.data()!),
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
              .map((doc) => doc.data()!)
              .toList());

      prefs.setString('groups', jsonEncode(expirableGroupsJson));
    }

    return expirableGroupsJson.data
        .map(
          (groupJson) => Group.fromJson(groupJson),
        )
        .toList();
  }

  @override
  Future<List<Group>> getGroups(int course, String facultyId) async {
    return (await this.getAllGroups())
        .where((group) => group.year == course && group.facultyId == facultyId)
        .toList();
  }

  @override
  Future<Timetable.Group> getGroupById(String groupId) async {
    return (await this.getAllGroups())
        .map((e) => Timetable.Group.fromObject(e))
        .firstWhere((group) => group.id == groupId);
  }

  @override
  Future<ContactsData> loadContactsData() async {
    ContactsData contactsData = ContactsData.fromJson(
        (await FirebaseFirestore.instance.collection('contacts').get())
            .docs
            .first
            .data()!);

    return contactsData;
  }

  Future<void> changeUserInfo(String userId, Map<String, dynamic> data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey('timetable.group.my')) {
      sharedPreferences.remove('timetable.group.my');
    }

    return (await FirebaseFirestore.instance
            .collection("users")
            .where("userId", isEqualTo: userId)
            .get())
        .docs
        .first
        .reference
        .update(data);
  }

  @override
  Future<Map<String, dynamic>?> getUserInfo(String userId) async =>
      (await FirebaseFirestore.instance
              .collection("users")
              .where("userId", isEqualTo: userId)
              .get())
          .docs
          .first
          .data();
}
