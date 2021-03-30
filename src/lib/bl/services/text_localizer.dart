import 'package:easy_localization/easy_localization.dart';

import 'package:faculty_list/faculty_list.dart' as FacultyList show TextLocalizer;

class TextLocalizer implements FacultyList.TextLocalizer {
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}