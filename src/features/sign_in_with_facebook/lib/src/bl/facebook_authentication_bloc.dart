import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

import 'package:sign_in_with_facebook/src/bl/models/facebook_user.dart';

class FacebookAuthenticationBloc {
  final StreamSink<String> errorSink;

  FacebookAuthenticationBloc({
    required this.errorSink,
  });

  var _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<FacebookUser?> _userController = BehaviorSubject();

  Stream<FacebookUser?> get user => _userController.stream;

  void loadUser() async {
    try {
      await FacebookAuth.instance.getUserData();

      _userController
          .add(FacebookUser.fromLogin(FirebaseAuth.instance.currentUser!));
    } catch (err) {
      //errorSink.add(err.toString());
    }
  }

  Future<void> login() async {
    try {
      _logger.d('start');
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled ||
          result.status == LoginStatus.failed) {
        _logger.d('return');
        return;
      }

      _userController.add(null);

      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      User? user = (await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential))
          .user;

      _logger.d('Signed in Facebook user');
      _logger.d(user);

      _userController.add(FacebookUser.fromLogin(user!));
    } catch (err, stack) {
      _logger.e('error');
      _logger.e(err);
      _logger.e(stack);
      errorSink.add(err.toString());
      _userController.add(FacebookUser.empty());
    }
  }

  Future<void> logout() async {
    _logger.d('F logout');
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut();

    _userController.add(FacebookUser.empty());
  }

  void dispose() {
    _userController.close();
  }
}
