import 'package:easy_localization/easy_localization.dart';

import 'package:timetable/timetable.dart' as TimetableScreen show ITextLocalizer;
class TextLocalizer
    implements
        TimetableScreen.ITextLocalizer{
  @override
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}
