import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_selection/src/bl/abstractions/groups_loader.dart';
import 'package:group_selection/src/bl/bloc/group_selection_bloc.dart';
import 'package:group_selection/src/bl/models/models.dart';

import '../../group_selection.dart';

class GroupSelectionScreen extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final GroupsLoader groupsLoader;

  GroupSelectionScreen(
      {required this.textLocalizer, required this.groupsLoader})
      : super();

  @override
  _GroupSelectionScreenState createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  int? course;
  Group? group;
  Subgroup? subgroup;
  late String facultyId;
  late GroupSelectionBloc groupSelectionBloc;
  bool isMyGroup = false;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  @override
  void initState() {
    groupSelectionBloc = GroupSelectionBloc(groupsLoader: widget.groupsLoader);

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
    facultyId = ModalRoute.of(context)!.settings.arguments.toString();
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
        title: Text(widget.textLocalizer.localize('Schedule')),
      ),
      body: Column(
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
                    child: DropdownButton<int>(
                      hint: Text(widget.textLocalizer.localize('Course')),
                      isExpanded: true,
                      value: course,
                      onChanged: (int? course) {
                        setState(() {
                          this.course = course;
                          group = null;
                          subgroup = null;
                        });
                        groupSelectionBloc.loadGroups(course!, facultyId);
                      },
                      items: <int>[1, 2, 3, 4, 5]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
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
                          hint: Text(widget.textLocalizer.localize('Group')),
                          isExpanded: true,
                          value: group,
                          onChanged: (Group? newValue) {
                            setState(() {
                              subgroup = null;
                              group = newValue;
                            });
                          },
                          items: snapshot.hasData == true && snapshot.data != null
                              ? snapshot.data!.map<DropdownMenuItem<Group>>((Group group) {
                                  return DropdownMenuItem<Group>(
                                    value: group,
                                    child: Text(group.name),
                                  );
                                }).toList()
                              : null,
                        ),
                      );
                    }
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  group != null &&
                          group!.subgroups != null &&
                          group!.subgroups!.length > 0
                      ? Column(
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
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: isMyGroup,
                          onChanged: (value) {
                            setState(() {
                              isMyGroup = value!;
                            });
                          }),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                              widget.textLocalizer.localize('It`s my group')),
                        ),
                        onTap: () {
                          setState(() {
                            isMyGroup = !isMyGroup;
                          });
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: course == null ||
                      group == null ||
                      (group!.subgroups != null &&
                          group!.subgroups!.length > 0 &&
                          subgroup == null)
                  ? null
                  : () => {},
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Text(
                  widget.textLocalizer.localize('Continue'),
                  textScaleFactor: 1.3,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    groupSelectionBloc.dispose();
    super.dispose();
  }
}
