import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_authentication/google_authentication.dart';
import 'package:error_bloc/error_bloc.dart';
import 'package:push_notification/push_notification.dart';
import 'package:user_sync/user_sync.dart' hide User;
import 'package:zhytomyr_polytechnic/bl/repositories/main_firestore_repository.dart';

import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

class Dependencies extends StatelessWidget {
  final Widget child;

  const Dependencies({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<ErrorBloc>(create: getErrorBloc),
          Provider<TextLocalizer>(create: getTextLocalizer),
        ],
        child: MultiProvider(
          providers: [
            Provider<PushNotificationBloc>(create: getNotificationBloc)
          ],
          child: MultiProvider(
            providers: [
              Provider<UserSyncBloc>(create: getUserSyncBloc),
            ],
            child: MultiProvider(providers: [
              Provider<GoogleAuthenticationBloc>(create: getAuthenticationBloc),
            ], child: child),
          ),
        ),
      );

  FirebaseFirestore getFirebaseFirestore() => FirebaseFirestore.instance;

  ErrorBloc getErrorBloc(BuildContext context) => ErrorBloc()
    ..error.debounceTime(Duration(milliseconds: 500)).listen((errorMessage) {
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
    });

  GoogleAuthenticationBloc getAuthenticationBloc(BuildContext context) =>
      GoogleAuthenticationBloc(errorSink: context.read<ErrorBloc>().errorSink)
        ..user.listen((user) {
          if (user != null && user.uid == "") {
            return context.read<UserSyncBloc>().cleanData();
          }
          context.read<UserSyncBloc>().setData(user == null ? null : user.uid);
        });

  UserSyncBloc getUserSyncBloc(BuildContext context) => UserSyncBloc(
      errorSink: context.read<ErrorBloc>().errorSink,
      repository: FirestoreRepository())
    ..loadUser()
    ..mappedUser
        .where((user) => user != null && !user.isEmpty)
        .map((user) => user!.data)
        .listen(context.read<PushNotificationBloc>().subscribeToNew);

  PushNotificationBloc getNotificationBloc(BuildContext context) =>
      PushNotificationBloc(errorSink: context.read<ErrorBloc>().errorSink);

  TextLocalizer getTextLocalizer(BuildContext context) => TextLocalizer();
}
