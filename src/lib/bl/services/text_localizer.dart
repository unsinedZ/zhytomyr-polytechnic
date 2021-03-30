import 'package:easy_localization/easy_localization.dart';

import 'package:faculty_list/faculty_list.dart' as FacultyListLocale show TextLocalizer;

class TextLocalizer implements FacultyListLocale.TextLocalizer {
  @override
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}