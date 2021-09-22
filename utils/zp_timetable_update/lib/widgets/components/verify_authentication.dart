import 'dart:async';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
    final authorizationBloc = context.read<AuthorizationBloc>();

    _authSubscription = authorizationBloc.authClient
        .where((authClient) => authClient == null)
        .listen((_) {
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
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
