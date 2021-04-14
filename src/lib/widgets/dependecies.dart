import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:google_authentication/google_authentication.dart';

import 'package:error_bloc/error_bloc.dart';

import 'package:rxdart/rxdart.dart';

import 'package:fluttertoast/fluttertoast.dart';

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
            Provider<AuthenticationBloc>(create: getUserBloc),
          ],
          child: child,
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

  TextLocalizer getTextLocalizer(BuildContext context) => TextLocalizer();

  AuthenticationBloc getUserBloc(BuildContext context) =>
      AuthenticationBloc(errorSink: context.read<ErrorBloc>().errorSink);
}
