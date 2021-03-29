import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_selection_screen/models/models.dart';

import '../models/models.dart';

class GroupSelectionScreen extends StatefulWidget {
  @override
  _GroupSelectionScreenState createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  int? course;
  List<Group>? groups;
  Group? group;
  Subgroup? subgroup;
  String? facultyId;
  bool isMyGroup = false;

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
        title: Text('Schedule'),
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
                    package: 'group_selection_screen',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Chose course and group',
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton<int>(
                    hint: Text('Course'),
                    isExpanded: true,
                    value: course,
                    onChanged: (int? newValue) {
                      setState(() {
                        groups = [
                          Group(name: 'group_1_' + newValue!.toString()),
                          Group(name: 'group_2_' + newValue.toString()),
                          Group(name: 'group_3_' + newValue.toString()),
                          Group(
                              name: 'group_4_' + newValue.toString(),
                              subgroups: [
                                Subgroup(
                                    name: 'subgroup_1_' + newValue.toString()),
                                Subgroup(
                                    name: 'subgroup_2_' + newValue.toString()),
                                Subgroup(
                                    name: 'subgroup_3_' + newValue.toString()),
                                Subgroup(
                                    name: 'subgroup_4_' + newValue.toString()),
                              ]),
                          Group(name: 'group_5_' + newValue.toString()),
                        ];
                        group = null;
                        subgroup = null;
                        course = newValue;
                      });
                    },
                    items: <int>[1, 2, 3, 4, 5]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton<Group>(
                    hint: Text('Group'),
                    isExpanded: true,
                    value: group,
                    onChanged: (Group? newValue) {
                      setState(() {
                        subgroup = null;
                        group = newValue;
                      });
                    },
                    items: groups != null
                        ? groups!.map<DropdownMenuItem<Group>>((Group group) {
                            return DropdownMenuItem<Group>(
                              value: group,
                              child: Text(group.name!),
                            );
                          }).toList()
                        : null,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  group != null &&
                          group!.subgroups != null &&
                          group!.subgroups!.length > 0
                      ? Column(
                          children: [
                            DropdownButton<Subgroup>(
                              hint: Text('Subgroup'),
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
                                        child: Text(subgroup.name!),
                                      );
                                    }).toList()
                                  : null,
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
                          child: Text('It`s my group'),
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
                  'Continue',
                  textScaleFactor: 1.3,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
