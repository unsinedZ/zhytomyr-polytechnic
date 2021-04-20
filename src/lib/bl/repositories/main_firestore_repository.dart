import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:faculty_list/faculty_list.dart';

import 'package:group_selection/group_selection.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timetable/timetable.dart' as Timetable;
import 'package:zhytomyr_polytechnic/bl/models/expirable.dart';

class FirestoreRepository
    implements FacultyRepository, GroupsRepository, Timetable.GroupRepository {
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
  Future<void> saveUserGroup(
      String userId, String groupId, String subgroupId) async {
    SharedPreferences sharedPreferences =
        (await SharedPreferences.getInstance());

    sharedPreferences.setString('userGroup', groupId);

    Map<String, dynamic> data = {
      'userId': userId,
      'groupId': groupId,
      'subgroupId': subgroupId,
    };

    List<QueryDocumentSnapshot> documents =
        (await FirebaseFirestore.instance.collection('users').get())
            .docs
            .where((element) => element.data()!['userId'] == userId)
            .toList();

    if (documents.isNotEmpty) {
      documents.first.reference.set(data);
    } else {
      await FirebaseFirestore.instance.collection('users').add(data);
    }
  }
}
