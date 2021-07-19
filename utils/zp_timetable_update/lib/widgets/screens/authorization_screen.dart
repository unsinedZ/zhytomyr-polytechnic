import 'dart:async';
import 'dart:io';

import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:flutter/material.dart';
import 'package:zp_timetable_update/bl/services/files_picker.dart';
import 'package:provider/provider.dart';
import 'package:zp_timetable_update/widgets/components/submit_button.dart';

class AuthorizationScreen extends StatefulWidget {
  AuthorizationScreen({Key? key}) : super(key: key);

  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final FilesPicker _filesPicker = FilesPicker(defaultExtension: "json");
  late final AuthorizationBloc _authorizationBloc;
  late final StreamSubscription _tokenSubscription;

  @override
  void initState() {
    _authorizationBloc = context.read<AuthorizationBloc>();

    _tokenSubscription = _authorizationBloc.authClient
        .where((client) => client != null)
        .listen((client) {
      Navigator.pushReplacementNamed(context, "/main_screen", arguments: {
        'id': 60,
        'client': client,
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tokenSubscription.cancel();
    super.dispose();
  }

  void _login() async {
    File? file = await _filesPicker.open();
    if (file == null) {
      return;
    }
    _authorizationBloc.login(await file.readAsString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<AuthClient?>(
          stream: _authorizationBloc.authClient,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      SubmitButton(
                          onTap: _login,
                          text: "Ввійти",
                          color: Theme.of(context).buttonColor)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
