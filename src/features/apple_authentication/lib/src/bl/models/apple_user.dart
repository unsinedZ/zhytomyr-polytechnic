import 'package:firebase_auth/firebase_auth.dart';

class AppleUser {
  final String uid;

  AppleUser({
    required this.uid,
  });

  factory AppleUser.fromLogin(User user) => AppleUser(
    uid: user.uid,
  );

  factory AppleUser.empty() => AppleUser(
    uid: "",
  );
}
