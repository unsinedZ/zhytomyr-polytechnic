import 'package:firebase_auth/firebase_auth.dart';

class Metadata {
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  Metadata({required this.creationTime, required this.lastSignInTime});

  factory Metadata.fromUserMetadata(UserMetadata userMetadata) => Metadata(
      creationTime: userMetadata.creationTime,
      lastSignInTime: userMetadata.lastSignInTime);

  factory Metadata.empty() => Metadata(
        creationTime: null,
        lastSignInTime: null,
      );
}
