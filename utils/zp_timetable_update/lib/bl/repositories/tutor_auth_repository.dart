import 'package:googleapis/firestore/v1.dart';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:zp_timetable_update/bl/const.dart';

class TutorAuthRepository
    implements ITutorAuthRepository {

  @override
  Future<int> loadTutorId(AuthClient client, String clientId) async {
    FirestoreApi firestoreApi = FirestoreApi(client);

    Document tutorDocument = await firestoreApi.projects.databases.documents.get(
        'projects/${Const.FirebaseProjectId}/databases/(default)/documents/service_accounts/' +
            clientId);

    return int.parse(tutorDocument.fields!['tutorId']!.integerValue!);
  }
}
