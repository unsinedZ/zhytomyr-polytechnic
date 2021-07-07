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
  String? text = "";

  @override
  void initState() {
    _authorizationBloc = context.read<AuthorizationBloc>();
    super.initState();
  }

  void _login() =>
      _filesPicker.open().then((value) => _authorizationBloc.login(value!));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
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
                SubmitButton(onTap: _login, text: "login", color: Theme.of(context).buttonColor)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
