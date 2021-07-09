import 'dart:async';
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationBloc {
  final StreamSink errorSink;

  AuthorizationBloc({required this.errorSink});

  final BehaviorSubject<AuthClient?> _authorizationController =
      BehaviorSubject<AuthClient?>();

  Stream<AuthClient?> get authClient => _authorizationController.stream;

  void loadUser() async {
    final storage = await SharedPreferences.getInstance();
    String? serviceAccount = storage.getString("account");
    if (serviceAccount == null) {
      return _authorizationController.add(null);
    }
    login(storage.getString("account")!);
  }

  void login(String serviceAccount) async {
    try {
      final storage = await SharedPreferences.getInstance();
      final clientCredentials =
          ServiceAccountCredentials.fromJson(jsonDecode(serviceAccount));
      final accessCredentials = await clientViaServiceAccount(
        clientCredentials,
        [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/datastore"
        ],
      );
      storage.setString("account", serviceAccount);
      _authorizationController.add(accessCredentials);
    } catch (error) {
      _authorizationController.add(null);
      errorSink.add(error.toString());
      print(error.toString());
    }
  }

  void logout() async {
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
    _authorizationController.add(null);
  }
}
