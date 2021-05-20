import 'package:easy_localization/easy_localization.dart';

import 'package:group_selection/group_selection.dart' as GroupSelection
    show TextLocalizer;

import 'package:faculty_list/faculty_list.dart' as FacultyListLocale
    show TextLocalizer;

import 'package:timetable/timetable.dart' as TimetableScreen show TextLocalizer;

import 'package:navigation_drawer/navigation_drawer.dart' as NavigationDrawer
    show TextLocalizer;

import 'package:contacts/contacts.dart' as Contacts show TextLocalizer;
import 'package:terms_and_conditions/terms_and_conditions.dart' as Terms show TextLocalizer;

class TextLocalizer
    implements
        FacultyListLocale.TextLocalizer,
        GroupSelection.TextLocalizer,
        TimetableScreen.TextLocalizer,
        Contacts.TextLocalizer,
        NavigationDrawer.TextLocalizer,
        Terms.TextLocalizer {
  @override
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}
