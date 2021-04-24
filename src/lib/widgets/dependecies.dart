import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_authentication/google_authentication.dart';
import 'package:error_bloc/error_bloc.dart';
import 'package:push_notification/push_notification.dart';
import 'package:user_sync/user_sync.dart' hide User;

import 'package:zhytomyr_polytechnic/bl/firestore_repository.dart';

class Dependencies extends StatelessWidget {
  final Widget child;

  const Dependencies({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<ErrorBloc>(create: getErrorBloc),
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
              Provider<AuthenticationBloc>(create: getAuthenticationBloc),
            ], child: child),
          ),
        ),
      );

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

  AuthenticationBloc getAuthenticationBloc(BuildContext context) =>
      AuthenticationBloc(errorSink: context.read<ErrorBloc>().errorSink)
        ..user
            .where((user) => user != null)
            .listen((user) => context.read<UserSyncBloc>().setData(user!.uid));

  UserSyncBloc getUserSyncBloc(BuildContext context) =>
      UserSyncBloc(repository: FirestoreRepository())
        ..loadUser()
        ..mappedUser
            .where((user)=> !user!.isEmpty)
            .map((user) => user!.toJson())
            .listen(context.read<PushNotificationBloc>().subscribeToNew);

  PushNotificationBloc getNotificationBloc(BuildContext context) =>
      PushNotificationBloc();
}
