import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty_list/faculty_list.dart';
import 'package:timetable_screen/timetable_screen.dart';

class FirestoreFacultyRepository implements FacultyRepository, TimetableLoader {
  @override
  Stream<List<Faculty>> getList() =>
      FirebaseFirestore.instance.collection('faculty').get().asStream().map(
            (facultyListJson) => facultyListJson.docs
                .map(
                  (facultyJson) => Faculty.fromJson(facultyJson.data()!),
                )
                .toList(),
          );

  @override
  Future<Timetable> loadTimetable(WeekDetermination weekDetermination) async {
    print('loadTimetable');
    return FirebaseFirestore.instance.collection('timetable').get().then(
        (timetablesListJson) => timetablesListJson.docs
            .map((timetableJson) => Timetable.fromJson(timetableJson.data()!))
            .firstWhere((timetable) {
              print(timetable);
              print(timetable.weekDetermination);
          return timetable.weekDetermination == weekDetermination;
        }));
  }
}
