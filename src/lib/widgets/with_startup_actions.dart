import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:error_bloc/error_bloc.dart';
import 'package:google_authentication/google_authentication.dart';
import 'package:apple_authentication/apple_authentication.dart';
import 'package:facebook_authentication/facebook_authentication.dart';
import 'package:push_notification/push_notification.dart';
import 'package:user_sync/user_sync.dart';
import 'package:update_check/update_check.dart';

class WithStartupActions extends StatefulWidget {
  final Widget child;

  const WithStartupActions({
    required this.child,
  });

  @override
  _WithStartupActionsState createState() => _WithStartupActionsState();
}

class _WithStartupActionsState extends State<WithStartupActions> {
  @override
  void initState() {
    final userSyncBloc = context.read<UserSyncBloc>();

    userSyncBloc.mappedUser
        .where((user) => user != null && !user.isEmpty)
        .map((user) => user)
        .listen((user) {
      context
          .read<PushNotificationBloc>()
          .subscribeToNew(user!.groupId, user.subgroupId);
    });

    context
        .read<ErrorBloc>()
        .error
        .debounceTime(Duration(milliseconds: 500))
        .listen((errorMessage) {
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white70,
          textColor: Colors.black,
          fontSize: 16.0);
    });

    context.read<GoogleAuthenticationBloc>().user.listen((user) {
      if (user?.uid == "") {
        context.read<UserSyncBloc>().cleanData();
        return;
      }

      context.read<UserSyncBloc>().setData(user?.uid, AuthProvider.Google);
    });

    context.read<FacebookAuthenticationBloc>().user.listen((user) {
      if (user?.uid == "") {
        context.read<UserSyncBloc>().cleanData();
        return;
      }

      context.read<UserSyncBloc>().setData(user?.uid, AuthProvider.Facebook);
    });

    context.read<AppleAuthenticationBloc>().user.listen((user) {
      if (user?.uid == "") {
        context.read<UserSyncBloc>().cleanData();
        return;
      }

      context.read<UserSyncBloc>().setData(user?.uid, AuthProvider.Apple);
    });

    context.read<UpdateCheckBloc>().checkForUpdates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
