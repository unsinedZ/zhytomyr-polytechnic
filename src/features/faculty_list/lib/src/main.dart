import 'package:faculty_list/src/bloc/faculty_list_bloc.dart';
import 'package:faculty_list/src/components/faculty_icon.dart';
import 'package:faculty_list/src/plugin_constasts.dart';
import 'package:faculty_list_abstractions/faculty_list_abstractions.dart';
import 'package:flutter/material.dart';

class FacultyList extends StatefulWidget {
  final FacultyRepository facultyRepository;
  final VoidCallback sidebarAction;

  FacultyList({required this.facultyRepository, required this.sidebarAction});

  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  late FacultyListBloc _facultyListBloc;

  @override
  void initState() {
    _facultyListBloc =
        FacultyListBloc(facultyRepository: widget.facultyRepository);
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
        leading: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: InkWell(
            onTap: widget.sidebarAction,
            child: Icon(Icons.menu),
          ),
        ),
        title: Text(PluginConstants.appBarHeader),
      ),
      body: RefreshIndicator(
        onRefresh: () => _facultyListBloc.loadList(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: StreamBuilder(
            stream: _facultyListBloc.faculties,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(PluginConstants.facultyListHeader, style: Theme.of(context).textTheme.headline6,),
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        alignment: WrapAlignment.center,
                        children: (snapshot.data as List<Faculty>)
                            .map(
                              (facultyList) => FacultyIcon(
                                key: Key(facultyList.name),
                                faculty: facultyList,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()]);
            },
          ),
        ),
      ),
    );
  }
}
