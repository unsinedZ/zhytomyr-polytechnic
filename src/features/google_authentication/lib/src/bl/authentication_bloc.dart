import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

class AuthenticationBloc {
  final StreamSink<String> errorSink;

  AuthenticationBloc({
    required this.errorSink,
  });

  var _logger = Logger(
    printer: PrettyPrinter(),
  );

  final BehaviorSubject<User?> _userController = BehaviorSubject();
  final BehaviorSubject<bool> _isLoginNowController = BehaviorSubject();

  Stream<User?> get user => _userController.stream;

  Stream<bool> get isLoginNow => _isLoginNowController.stream;

  void loadUser() async {
    try {
      _isLoginNowController.add(true);
      if (await GoogleSignIn().isSignedIn()) {
        _userController.add(FirebaseAuth.instance.currentUser);
      }
    } catch (err) {
      errorSink.add(err.toString());
    } finally {
      _isLoginNowController.add(false);
    }
  }

  Future<void> login() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      _isLoginNowController.add(true);

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      _logger.d('Signed in Google user');
      _logger.d(user);

      _userController.add(user);
    } catch (err) {
      errorSink.add(err.toString());
      _userController.add(null);
    } finally {
      _isLoginNowController.add(false);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    _userController.add(null);
  }

  void dispose() {
    _userController.close();
    _isLoginNowController.close();
  }
}
