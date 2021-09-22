import 'dart:async';
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:authorization_bloc/src/bl/abstractions/tutor_auth_repository.dart';

class AuthorizationBloc {
  final StreamSink errorSink;
  final ITutorAuthRepository tutorAuthRepository;

  AuthorizationBloc({
    required this.errorSink,
    required this.tutorAuthRepository,
  });

  final BehaviorSubject<AuthClient?> _authClientSubject =
      BehaviorSubject<AuthClient?>();

  final BehaviorSubject<int> _tutorIdSubject = BehaviorSubject<int>();

  ValueStream<AuthClient?> get authClient => _authClientSubject.stream;

  ValueStream<int> get tutorId => _tutorIdSubject.stream;

  void loadUser() async {
    final storage = await SharedPreferences.getInstance();
    String? serviceAccount = storage.getString("account");
    if (serviceAccount == null) {
      return _authClientSubject.add(null);
    }
    login(serviceAccount);
  }

  void login(String serviceAccount) async {
    try {
      final storage = await SharedPreferences.getInstance();
      final clientCredentials =
          ServiceAccountCredentials.fromJson(jsonDecode(serviceAccount));
      final authClient = await clientViaServiceAccount(
        clientCredentials,
        [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/datastore"
        ],
      );
      storage.setString("account", serviceAccount);
      await loadTutorId(authClient, clientCredentials.clientId.identifier);
      _authClientSubject.add(authClient);
    } catch (error) {
      _authClientSubject.add(null);
      errorSink.add(error.toString());
      print(error.toString());
    }
  }

  Future<void> loadTutorId(AuthClient client, String clientId) async {
    try {
      int tutorId = await tutorAuthRepository.loadTutorId(client, clientId);
      _tutorIdSubject.add(tutorId);
    } catch(error, stack) {
      errorSink.add(error.toString());
      print(error);
      print(stack);
      _tutorIdSubject.add(-1);
    }
  }

  void logout() async {
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
    _authClientSubject.add(null);
  }

  void dispose() {
    _authClientSubject.close();
    _tutorIdSubject.close();
  }
}
