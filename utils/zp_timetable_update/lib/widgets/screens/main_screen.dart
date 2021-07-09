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
    GroupTimetableFirestoreRepository groupTimetableFirestoreRepository =
        GroupTimetableFirestoreRepository(client: context.read<AuthorizationBloc>().client);
    groupTimetableFirestoreRepository.test();
    return Container(
      child: Text("asd"),
    );
  }
}
