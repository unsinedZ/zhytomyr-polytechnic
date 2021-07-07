import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:flutter/material.dart';
import 'package:zp_timetagle_changer/bl/services/files_picker.dart';

class AuthorizationScreen extends StatefulWidget {
  AuthorizationScreen({Key? key}) : super(key: key);

  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final FilesPicker _filesPicker = FilesPicker(defaultExtension: "json");
  AuthorizationBloc _authorizationBloc = AuthorizationBloc();
  String? text = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                  color: Colors.blue,
                  onPressed: () => _filesPicker
                      .open()
                      .then((value) => _authorizationBloc.login(value!)))
              //Text(text!),
            ],
          ),
        ),
      ),
    );
  }
}
