import 'package:authorization_bloc/authorization_bloc.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:zp_timetable_update/bl/repositories/group_timetable_firestore_repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final _authorizationBloc = context.read<AuthorizationBloc>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<AuthClient?>(
        stream: _authorizationBloc.authClient,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }



        return Container(
          child: Text("asd"),
        );
      }
    );
  }
}
