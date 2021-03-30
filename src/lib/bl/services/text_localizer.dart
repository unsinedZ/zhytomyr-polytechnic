import 'package:easy_localization/easy_localization.dart';

import 'package:group_selection/group_selection.dart' as GroupSelection
    show TextLocalizer;

import 'package:faculty_list/faculty_list.dart' as FacultyListLocale
    show TextLocalizer;

class TextLocalizer
    implements FacultyListLocale.TextLocalizer, GroupSelection.TextLocalizer {
  @override
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}
