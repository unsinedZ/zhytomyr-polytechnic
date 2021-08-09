import 'package:googleapis/firestore/v1.dart';

import 'package:authorization_bloc/authorization_bloc.dart';

class TutorAuthRepository
    implements ITutorAuthRepository {

  @override
  Future<int> loadTutorId(AuthClient client, String clientId) async {


    FirestoreApi firestoreApi = FirestoreApi(client);

    Document tutorDocument = await firestoreApi.projects.databases.documents.get(
        'projects/zhytomyr-politechnic-dev/databases/(default)/documents/service_accounts/' +
            clientId);

    return int.parse(tutorDocument.fields!['tutorId']!.integerValue!);
  }
}
