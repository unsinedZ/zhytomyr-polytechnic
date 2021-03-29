import 'package:faculty_list/faculty_list.dart';
import 'package:flutter/material.dart';
import 'bl/faculty_list_impl.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FacultyList(
          facultyRepository: FirestoreFacultyRepository(), sidebarAction: () {  },
        ),
      );
}
