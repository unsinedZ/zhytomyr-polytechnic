import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:deep_links/deep_links.dart';
import 'package:google_authentication/google_authentication.dart';
import 'package:error_bloc/error_bloc.dart';
import 'package:push_notification/push_notification.dart';
import 'package:update_check/update_check.dart';
import 'package:user_sync/user_sync.dart' hide User;
import 'package:zhytomyr_polytechnic/bl/repositories/main_firestore_repository.dart';

import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';
import 'package:zhytomyr_polytechnic/bl/repositories/main_firestore_repository.dart';

class Dependencies extends StatelessWidget {
  final Widget child;

  const Dependencies({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<ErrorBloc>(create: getErrorBloc),
          Provider<DeepLinkBloc>(create: getDeepLinkBloc),
          Provider<TextLocalizer>(create: getTextLocalizer),
        ],
        child: MultiProvider(
          providers: [
            Provider<PushNotificationBloc>(create: getNotificationBloc),
            Provider<UpdateCheckBloc>(create: getUpdateCheckBloc),
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

  UpdateCheckBloc getUpdateCheckBloc(BuildContext context) =>
      UpdateCheckBloc(errorSink: context.read<ErrorBloc>().errorSink, versionsRepository: FirestoreRepository());

  DeepLinkBloc getDeepLinkBloc(BuildContext context) =>
      DeepLinkBloc(errorSink: context.read<ErrorBloc>().errorSink)..initLink(['/timetable']);

  TextLocalizer getTextLocalizer(BuildContext context) => TextLocalizer();
}
