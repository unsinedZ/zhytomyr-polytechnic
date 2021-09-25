import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

import 'package:facebook_authentication/src/bl/models/facebook_user.dart';

class FacebookAuthenticationBloc {
  static const String providerId = "facebook.com";

  final StreamSink<String> errorSink;

  FacebookAuthenticationBloc({
    required this.errorSink,
  });

  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<FacebookUser?> _userSubject = BehaviorSubject();

  Stream<FacebookUser?> get user => _userSubject.stream;

  void loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.providerData.last.providerId == providerId) {
        _userSubject.add(FacebookUser.fromLogin(user));
      }
    } catch (err) {
      errorSink.add(err.toString());
    }
  }

  Future<void> login() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        return;
      }

      _userSubject.add(null);

      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      User? user = (await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential))
          .user;

      _logger.d('Signed in Facebook user');
      _logger.d(user);

      _userSubject.add(FacebookUser.fromLogin(user!));
    } catch (err) {
      errorSink.add(err.toString());
      _userSubject.add(FacebookUser.empty());
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut();

    _userSubject.add(FacebookUser.empty());
  }

  void dispose() {
    _userSubject.close();
  }
}
