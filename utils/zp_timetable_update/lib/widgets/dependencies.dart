import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:error_bloc/error_bloc.dart';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

class Dependencies extends StatelessWidget {
  final Widget child;

  const Dependencies({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<Client>(create: getHttpClient),
          Provider<ErrorBloc>(create: getErrorBloc),
        ],
        child: MultiProvider(providers: [
          Provider<AuthorizationBloc>(create: getAuthorizationBloc),
        ], child: this.child),
      );

  Client getHttpClient(BuildContext context) => Client();

  ErrorBloc getErrorBloc(BuildContext context) => ErrorBloc();

  AuthorizationBloc getAuthorizationBloc(BuildContext context) =>
      AuthorizationBloc(
        errorSink: context.read<ErrorBloc>().errorSink, client: context.read<Client>(),
      );
}
