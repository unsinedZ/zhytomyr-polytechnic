import 'package:firebase_auth/firebase_auth.dart';

class FacebookUser {
  final String uid;

  FacebookUser({
    required this.uid,
  });

  factory FacebookUser.fromLogin(User user) => FacebookUser(
    uid: user.uid,
  );

  factory FacebookUser.empty() => FacebookUser(
    uid: "",
  );
}
