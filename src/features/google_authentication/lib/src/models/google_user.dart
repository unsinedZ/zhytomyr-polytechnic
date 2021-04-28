import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_authentication/src/models/metadata.dart';

class GoogleUser {
  final String uid;
  final String? email;
  final bool emailVerified;
  final Metadata metadata;
  final String? phoneNumber;
  final String? photoURL;
  final bool isAnonymous;
  final String? tenantId;

  GoogleUser({
    required this.uid,
    required this.email,
    required this.emailVerified,
    required this.metadata,
    required this.phoneNumber,
    required this.photoURL,
    required this.isAnonymous,
    required this.tenantId,
  });

  factory GoogleUser.fromLogin(User user) => GoogleUser(
        uid: user.uid,
        email: user.email,
        emailVerified: user.emailVerified,
        metadata: Metadata.fromUserMetadata(user.metadata),
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL,
        isAnonymous: user.isAnonymous,
        tenantId: user.tenantId,
      );

  factory GoogleUser.empty() => GoogleUser(
        uid: "",
        email: null,
        emailVerified: false,
        metadata: Metadata.empty(),
        phoneNumber: null,
        photoURL: null,
        isAnonymous: false,
        tenantId: null,
      );
}
