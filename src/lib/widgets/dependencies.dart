import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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

  ErrorBloc getErrorBloc(BuildContext context) => ErrorBloc();

  GoogleAuthenticationBloc getAuthenticationBloc(BuildContext context) =>
      GoogleAuthenticationBloc(errorSink: context.read<ErrorBloc>().errorSink);

  UserSyncBloc getUserSyncBloc(BuildContext context) => UserSyncBloc(
      errorSink: context.read<ErrorBloc>().errorSink,
      repository: FirestoreRepository());

  PushNotificationBloc getNotificationBloc(BuildContext context) =>
      PushNotificationBloc(errorSink: context.read<ErrorBloc>().errorSink);

  TextLocalizer getTextLocalizer(BuildContext context) => TextLocalizer();
}
