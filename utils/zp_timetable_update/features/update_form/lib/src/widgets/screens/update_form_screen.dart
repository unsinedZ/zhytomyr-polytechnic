import 'dart:async';

import 'package:flutter/material.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:update_form/src/widgets/components/groupsMultiSelect.dart';
import 'package:uuid/uuid.dart';

import 'package:update_form/src/bl/bloc/update_form_bloc.dart';
import 'package:update_form/src/bl/extensions/groups_list_extension.dart';
import 'package:update_form/src/bl/models/activity.dart';
import 'package:update_form/src/bl/models/group.dart';
import 'package:update_form/src/bl/models/timeslot.dart';
import 'package:update_form/src/bl/models/timetable_item.dart';
import 'package:update_form/src/bl/models/timetable_item_update.dart';
import 'package:update_form/src/bl/models/tutor.dart';

class UpdateFormScreen extends StatefulWidget {
  final UpdateFormBloc updateFormBloc;
  final StreamSink<String> errorSink;

  const UpdateFormScreen({
    Key? key,
    required this.updateFormBloc,
    required this.errorSink,
  }) : super(key: key);

  @override
  _UpdateFormScreenState createState() => _UpdateFormScreenState();
}

class _UpdateFormScreenState extends State<UpdateFormScreen> {
  final TextEditingController lessonNameController = TextEditingController();
  final TextEditingController auditoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late StreamSubscription isUpdatingStreamSubscription;

  String groupsSelectionValidationMessage = '';
  String? startLessonTime;
  String? endLessonTime;

  List<Tutor> tutors = [];
  String? timetableItemType;
  late int dayNumber;
  late int weekNumber;
  late Tutor tutor;
  late DateTime dateTime;
  late List<Group>? initialGroups;

  TimetableItem? timetableItem;

  @override
  void initState() {
    isUpdatingStreamSubscription = widget.updateFormBloc.isUpdateCreating.listen((isUpdateCreating) {
      if (isUpdateCreating == true) {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return Container(
                color: Color(0x43000000),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      } else {
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final arguments =
        (ModalRoute.of(context)!.settings.arguments) as Map<String, dynamic>;

    dateTime = arguments['dateTime'];
    dayNumber = arguments['dayNumber'];
    weekNumber = arguments['weekNumber'];
    tutor = Tutor.fromJson(arguments['tutorJson']);
    timetableItem = arguments['timetableItemJson'] != null
        ? TimetableItem.fromJson(arguments['timetableItemJson'])
        : null;

    initialGroups = timetableItem?.activity.groups;
    if (timetableItem != null) {
      lessonNameController.text = timetableItem!.activity.name;
      auditoryController.text = timetableItem!.activity.room;
      startLessonTime = timetableItem!.activity.time.start;
      tutors = timetableItem!.activity.tutors;
      timetableItemType = timetableItem!.activity.type;

      widget.updateFormBloc
          .setSelectedGroups(timetableItem!.activity.groups.divide());
    }

    widget.updateFormBloc.loadGroups();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Створення заміни',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: StreamBuilder<List<Group>>(
          stream: widget.updateFormBloc.groups.map((event) => event.divide()),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<MultiSelectItem<Group>> items = snapshot.data!.map((group) {
              return MultiSelectItem(
                  group,
                  group.name +
                      (group.subgroups.isNotEmpty
                          ? ('(' + group.subgroups.first.name + ')')
                          : ''));
            }).toList();

            return SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: lessonNameController,
                        validator: (value) =>
                            _defaultValidator(value, 'Введіть назву заняття'),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: "Назва пари",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: DropdownButtonFormField<String?>(
                          hint: Text('Початок пари'),
                          disabledHint: Text('Початок пари'),
                          items: startEndLessonMap.keys
                              .map((key) => DropdownMenuItem(
                                  child: Text(key), value: key))
                              .toList(),
                          value: startLessonTime,
                          onChanged: (newValue) {
                            startLessonTime = newValue;
                          },
                          validator: (value) => _defaultValidator(
                              value, 'Виберіть час початку заняття'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: auditoryController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: "Аудиторія",
                        ),
                        validator: (value) =>
                            _defaultValidator(value, 'Введіть назву аудиторії'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: DropdownButtonFormField<String?>(
                          hint: Text('Тип заняття'),
                          items: [
                            DropdownMenuItem(
                                child: Text('Лекція'), value: 'Лекція'),
                            DropdownMenuItem(
                                child: Text('Практика'), value: 'Практика'),
                          ],
                          value: timetableItemType,
                          onChanged: (newValue) {
                            timetableItemType = newValue;
                          },
                          validator: (value) =>
                              _defaultValidator(value, 'Вибуріть тип заннятя'),
                        ),
                      ),
                    ),
                    StreamBuilder<List<Group>>(
                        stream: widget.updateFormBloc.selectedGroups,
                        initialData: [],
                        builder: (context, selectedGroupsSnapshot) {
                          return Column(
                            children: [
                              GroupsMultiSelect(
                                items: items,
                                removeGroup: (group) {
                                  widget.updateFormBloc
                                      .removeFromSelectedGroup(group);
                                },
                                selectedGroups: selectedGroupsSnapshot.data!,
                                onConfirm: (values) {
                                  widget.updateFormBloc.setSelectedGroups(
                                      values.map((group) => group!).toList());
                                },
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Створити заміну',
                                      textScaleFactor: 1.4,
                                    ),
                                  ),
                                  onPressed: () async {
                                    _onSubmit(selectedGroupsSnapshot.data!);
                                  },
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style!
                                      .copyWith(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Theme.of(context).disabledColor;
                                      }
                                      return Color(0xff36d02b);
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _onSubmit(List<Group> groups) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    TimetableItemUpdate timetableItemUpdate = _createTimetableUpdate(groups);
    await widget.updateFormBloc.createTimetableUpdate(timetableItemUpdate, groups.compress(), initialGroups);
    Navigator.pop(context);
    if(timetableItem != null) {
      Navigator.pop(context);
    }
  }

  TimetableItemUpdate _createTimetableUpdate(List<Group> selectedGroups) {
    var uuid = Uuid();
    String id = uuid.v4();

    TimetableItemUpdate timetableItemUpdate = TimetableItemUpdate(
      date: dateTime.year.toString() +
          '-' +
          (dateTime.month < 10
              ? '0' + dateTime.month.toString()
              : dateTime.month.toString()) +
          '-' +
          (dateTime.day < 10
              ? '0' + dateTime.day.toString()
              : dateTime.day.toString()),
      id: id,
      time: timetableItem?.activity.time.start ?? startLessonTime!,
      timetableItem: TimetableItem(
        dayNumber: dayNumber,
        weekNumber: weekNumber,
        activity: Activity(
          type: timetableItemType!,
          room: auditoryController.text,
          time: Timeslot(
            start: startLessonTime!,
            end: startEndLessonMap[startLessonTime!]!,
          ),
          tutors: [tutor],
          groups: selectedGroups.compress(),
          name: lessonNameController.text,
        ),
      ),
    );

    return timetableItemUpdate;
  }

  @override
  void dispose() {
    isUpdatingStreamSubscription.cancel();
    super.dispose();
  }
}

Map<String, String> startEndLessonMap = {
  '8:30': '9:50',
  '10:00': '11:20',
  '11:40': '13:00',
  '13:30': '14:50',
  '15:00': '16:20',
  '16:30': '17:50',
};

_defaultValidator(String? value, validationMessage) {
  if (value == null || value.isEmpty) {
    return validationMessage;
  } else {
    return null;
  }
}
