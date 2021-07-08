import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationBloc {
  final StreamSink errorSink;
  final Client client;

  AuthorizationBloc({required this.errorSink, required this.client});

  final StreamController<AccessToken?> _authorizationController =
      StreamController.broadcast();

  Stream<AccessToken?> get token => _authorizationController.stream;

  void loadUser() async {
    final storage = await SharedPreferences.getInstance();
    String? serviceAccount = storage.getString("account");
    if (serviceAccount == null) {
      return _authorizationController.add(AccessToken("", "", DateTime.utc(1970)));
    }
    login(storage.getString("account")!);
  }

  void login(String serviceAccount) async {
    try {
      _authorizationController.add(null);
      final storage = await SharedPreferences.getInstance();
      final clientCredentials =
          ServiceAccountCredentials.fromJson(jsonDecode(serviceAccount));
      final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        clientCredentials,
        [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/datastore"
        ],
        client,
      );
      storage.setString("account", serviceAccount);
      _authorizationController.add(accessCredentials.accessToken);
    } catch (error) {
      _authorizationController.add(AccessToken("", "", DateTime.utc(1970)));
      errorSink.add(error.toString());
      print(error.toString());
    }
  }

  void logout() async {
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
    _authorizationController.add(AccessToken("", "", DateTime.utc(1970)));
  }

  
}
