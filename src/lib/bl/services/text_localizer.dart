import 'package:easy_localization/easy_localization.dart';

import 'package:group_selection/group_selection.dart' as GroupSelection
    show TextLocalizer;

import 'package:faculty_list/faculty_list.dart' as FacultyListLocale
    show TextLocalizer;

import 'package:timetable/timetable.dart' as TimetableScreen show TextLocalizer;

import 'package:navigation_drawer/navigation_drawer.dart' as NavigationDrawer
    show TextLocalizer;

import 'package:contacts/contacts.dart' as Contacts show TextLocalizer;

class TextLocalizer
    implements
        FacultyListLocale.TextLocalizer,
        GroupSelection.TextLocalizer,
        TimetableScreen.TextLocalizer,
        Contacts.TextLocalizer,
        NavigationDrawer.TextLocalizer {
  @override
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}
