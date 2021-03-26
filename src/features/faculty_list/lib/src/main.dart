import 'package:faculty_list/src/bloc/faculty_list_bloc.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:faculty_list/src/components/faculty_icon.dart';

initFirebase() => Firebase.initializeApp();

class FacultyList extends StatefulWidget {
  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  final _facultyListBloc = FacultyListBloc();

  @override
  void initState() {
    _facultyListBloc.loadList();
    super.initState();
  }

  @override
  void dispose() {
    _facultyListBloc.dispose();
    super.dispose();
  }

// _facultyListBloc.loadList()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: InkWell(
            onTap: () {},
            child: Icon(Icons.menu),
          ),
        ),
        title: Text("Faculty List"),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(Duration(seconds: 1)),
        child: StreamBuilder(
          stream: _facultyListBloc.faculties,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // if (snapshot.hasData) {
            //   return GridView.builder(
            //     physics: ClampingScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: snapshot.data.length,
            //     padding: EdgeInsets.all(10),
            //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //       childAspectRatio: 0.95,
            //       maxCrossAxisExtent: 300,
            //       mainAxisSpacing: 15,
            //     ),
            //     itemBuilder: (BuildContext context, int index) => FacultyIcon(
            //       key: Key(snapshot.data[index].name),
            //       faculty: snapshot.data[index],
            //     ),
            //   );
            // }

            // if (snapshot.hasData) {
            //   return Wrap(
            //     alignment: WrapAlignment.center,
            //     children: (snapshot.data as List<Faculty>)
            //         .map(
            //           (facultyList) => FacultyIcon(
            //             key: Key(facultyList.name),
            //             faculty: facultyList,
            //           ),
            //         )
            //         .toList(),
            //   );
            // }

            return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
