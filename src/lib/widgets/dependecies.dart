import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:google_authentication/google_authentication.dart';

class Dependencies extends StatelessWidget {
  final Widget child;

  const Dependencies({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<AuthenticationBloc>(create: getUserBloc),
        ],
        child: child,
      );

  AuthenticationBloc getUserBloc(BuildContext context) =>
      AuthenticationBloc(errorSink: StreamController<String>().sink);
}
