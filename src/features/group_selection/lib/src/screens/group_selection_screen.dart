import 'dart:async';

import 'package:flutter/material.dart';

import 'package:group_selection/src/bl/abstractions/groups_repository.dart';
import 'package:group_selection/src/bl/abstractions/text_localizer.dart';
import 'package:group_selection/src/bl/bloc/group_selection_bloc.dart';
import 'package:group_selection/src/bl/models/models.dart';
import 'package:group_selection/src/components/checkbox_with_title.dart';
import 'package:group_selection/src/components/submit_button.dart';
import 'package:notification_permissions/notification_permissions.dart';

class GroupSelectionScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final GroupsRepository groupsLoader;
  final StreamSink<String> errorSink;
  final void Function(String, String) subscribeCallback;
  final Widget Function({required Widget child}) bodyWrapper;

  GroupSelectionScreen({
    required this.textLocalizer,
    required this.groupsLoader,
    required this.errorSink,
    required this.subscribeCallback,
    required this.bodyWrapper,
  });

  @override
  _GroupSelectionScreenState createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  final List<String> _years = ['1', '2', '3', '4', '1m', '2m'];

  String? course;
  Group? group;
  Subgroup? subgroup;
  late int facultyId;
  late String facultyName;
  late GroupSelectionBloc groupSelectionBloc;
  bool isMyGroup = false;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  @override
  void initState() {
    groupSelectionBloc = GroupSelectionBloc(
      groupsLoader: widget.groupsLoader,
      errorSink: widget.errorSink,
    );

    groupSelectionBloc.groups.listen((groups) {
      if (groups == null) {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return Container(
                  color: Color(0x43000000),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
            },
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    facultyId = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['facultyId'];
    facultyName = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['facultyName'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          facultyName,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: widget.bodyWrapper(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Spacer(),
                    Image.asset(
                      'assets/images/timetable.png',
                      package: 'group_selection',
                      width: mediaQuery.size.width * 0.4,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.textLocalizer.localize('Chose course and group'),
                      textAlign: TextAlign.center,
                      textScaleFactor: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 150,
                      child: DropdownButton<String>(
                        hint: Text(widget.textLocalizer.localize('Course')),
                        isExpanded: true,
                        value: course,
                        onChanged: (String? course) {
                          setState(() {
                            this.course = course;
                            group = null;
                            subgroup = null;
                          });
                          groupSelectionBloc.loadGroups(course!, facultyId);
                        },
                        items: _years
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<Group>?>(
                        stream: groupSelectionBloc.groups,
                        builder: (context, snapshot) {
                          return Container(
                            width: 150,
                            child: DropdownButton<Group>(
                              hint:
                                  Text(widget.textLocalizer.localize('Group')),
                              isExpanded: true,
                              value: group,
                              onChanged: (Group? newValue) {
                                setState(() {
                                  subgroup = null;
                                  group = newValue;
                                });
                              },
                              items: snapshot.hasData == true &&
                                      snapshot.data != null
                                  ? snapshot.data!.map<DropdownMenuItem<Group>>(
                                      (Group group) {
                                      return DropdownMenuItem<Group>(
                                        value: group,
                                        child: Text(group.name),
                                      );
                                    }).toList()
                                  : null,
                            ),
                          );
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    if (group != null &&
                        group!.subgroups != null &&
                        group!.subgroups!.length > 0)
                      Column(
                        children: [
                          Container(
                            width: 150,
                            child: DropdownButton<Subgroup>(
                              hint: Text(
                                  widget.textLocalizer.localize('Subgroup')),
                              isExpanded: true,
                              value: subgroup,
                              onChanged: (Subgroup? newValue) {
                                setState(() {
                                  subgroup = newValue;
                                });
                              },
                              items: group!.subgroups != null
                                  ? group!.subgroups!
                                      .map<DropdownMenuItem<Subgroup>>(
                                          (Subgroup subgroup) {
                                      return DropdownMenuItem<Subgroup>(
                                        value: subgroup,
                                        child: Text(subgroup.name),
                                      );
                                    }).toList()
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    CheckboxWithTitle(
                      title: widget.textLocalizer.localize('It`s my group'),
                      onChange: (bool? newValue) {
                        setState(() {
                          isMyGroup = newValue!;
                        });
                      },
                      value: isMyGroup,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            SubmitButton(
              subscribeCallback: widget.subscribeCallback,
              text: widget.textLocalizer.localize('Continue'),
              group: group,
              course: course,
              subgroup: subgroup,
              isMyGroup: isMyGroup,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupSelectionBloc.dispose();
    super.dispose();
  }
}
