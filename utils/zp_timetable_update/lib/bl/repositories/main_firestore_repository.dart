import 'package:authorization_bloc/authorization_bloc.dart';

import 'package:timetable/timetable.dart';
import 'package:zp_timetable_update/bl/api/timetable_update_api.dart';
import 'package:zp_timetable_update/bl/extensions/document_extension.dart';

class MainFirestoreRepository implements TutorRepository {
  @override
  Future<Tutor?> getTutorById(int teacherId, AuthClient client) async {
    List<Tutor> tutors = (await TimetableUpdateApi.runQuery(
      client: client,
      collectionId: 'tutors',
      fieldPath: 'id',
      fieldValue: teacherId.toString(),
      valueType: ValueType.Int,
    ))
        .map((tutorDocument) => Tutor.fromJson(tutorDocument.toJsonFixed()))
        .toList();

    if (tutors.isNotEmpty) {
      return tutors.first;
    } else {
      return null;
    }
  }
}
