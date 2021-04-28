import 'dart:async';

import 'package:flutter/material.dart';

import 'package:faculty_list/src/bl/bloc/faculty_list_bloc.dart';
import 'package:faculty_list/src/bl/models/faculty.dart';
import 'package:faculty_list/src/bl/abstractions/faculty_repository.dart';
import 'package:faculty_list/src/bl/abstractions/text_localizer.dart';
import 'package:faculty_list/src/widgets/components/faculty_icon.dart';

class FacultyList extends StatefulWidget {
  final FacultyRepository facultyRepository;
  final TextLocalizer textLocalizer;
  final StreamSink<String> errorSink;
  final Widget drawer;

  FacultyList({
    required this.facultyRepository,
    required this.textLocalizer,
    required this.errorSink,
    required this.drawer,
  });

  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  late FacultyListBloc _facultyListBloc;

  @override
  void initState() {
    _facultyListBloc = FacultyListBloc(
      facultyRepository: widget.facultyRepository,
      errorSink: widget.errorSink,
    );
    _facultyListBloc.loadList();
    super.initState();
  }

  @override
  void dispose() {
    _facultyListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.textLocalizer.localize("Faculty List"),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      drawer: widget.drawer,
      body: StreamBuilder<List<Faculty>>(
        stream: _facultyListBloc.faculties,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () => _facultyListBloc.loadList(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            widget.textLocalizer.localize("Choose faculty"),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        alignment: WrapAlignment.center,
                        children: (snapshot.data as List<Faculty>)
                            .map(
                              (facultyList) => FacultyIcon(
                                faculty: facultyList,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
