import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faculty_list/faculty_list.dart';

class FirestoreFacultyRepository implements FacultyRepository {
  @override
  Stream<List<Faculty>> getList() =>
      FirebaseFirestore.instance.collection('faculty').get().asStream().map(
            (facultyListJson) => facultyListJson.docs.map(
              (facultyJson) => Faculty.fromJson(facultyJson.data()!),
            ).toList(),
          );
}
