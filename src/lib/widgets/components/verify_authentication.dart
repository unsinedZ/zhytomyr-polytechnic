import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_sync/user_sync.dart';

class VerifyAuthentication extends StatefulWidget {
  final Widget child;

  const VerifyAuthentication({
    required this.child,
  });

  @override
  _VerifyAuthenticationState createState() => _VerifyAuthenticationState();
}

class _VerifyAuthenticationState extends State<VerifyAuthentication> {
  late StreamSubscription _authSubscription;

  @override
  void initState() {
    final authenticationBloc = context.read<UserSyncBloc>();

    _authSubscription = authenticationBloc.mappedUser
        .where((user) => user != null && user.isEmpty)
        .asyncMap(
            (_) async => await (await SharedPreferences.getInstance()).clear())
        .listen((_) {
      Phoenix.rebirth(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
