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

  final BehaviorSubject<User?> _userController = BehaviorSubject();
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  Stream<User?> get user => _userController.stream;

  void loadUser() async {
    try {
      _userController.add(null);

      if (await GoogleSignIn().isSignedIn()) {
        _userController.add(FirebaseAuth.instance.currentUser);
      }
    } catch (err) {
      _userController.add(null);
      errorSink.add(err.toString());
    }
  }

  Future<void> login() async {
    _userController.add(null);

    try {
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
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    _userController.add(null);
  }

  void dispose() {
    _userController.close();
  }
}
