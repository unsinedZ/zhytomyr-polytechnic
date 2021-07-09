import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:error_bloc/error_bloc.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
        child: MultiProvider(providers: [
          Provider<AuthorizationBloc>(create: getAuthorizationBloc),
        ], child: this.child),
      );

  ErrorBloc getErrorBloc(BuildContext context) => ErrorBloc();

  AuthorizationBloc getAuthorizationBloc(BuildContext context) =>
      AuthorizationBloc(
        errorSink: context.read<ErrorBloc>().errorSink,
      );
}
