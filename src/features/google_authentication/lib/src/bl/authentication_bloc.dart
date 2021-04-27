import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

class AuthenticationBloc {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final StreamSink<String> errorSink;

  AuthenticationBloc({
    required this.errorSink,
  });

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
      _isLoginNowController.add(true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      logger.d('Signed in Google user');
      logger.d(user);

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
