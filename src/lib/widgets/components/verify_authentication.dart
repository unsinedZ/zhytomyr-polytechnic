import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:google_authentication/google_authentication.dart';

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
    final authenticationBloc = context.read<AuthenticationBloc>();

    _authSubscription = authenticationBloc.user
        .where((user) => user == null)
        .listen((_) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, '/authentication');
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
