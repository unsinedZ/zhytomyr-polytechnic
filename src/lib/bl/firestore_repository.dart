import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty_list/faculty_list.dart';
import 'package:group_selection/group_selection.dart';
import 'package:timetable/timetable.dart' hide Group;

class FirestoreRepository
    implements FacultyRepository, GroupsLoader, TimetableLoader {
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
  Future<Timetable> loadTimetable(WeekDetermination weekDetermination) async =>
      FirebaseFirestore.instance.collection('timetable').get().then(
          (timetablesListJson) => timetablesListJson.docs
              .map((timetableJson) => Timetable.fromJson(timetableJson.data()!))
              .firstWhere((timetable) =>
                  timetable.weekDetermination == weekDetermination));
}