import 'package:easy_localization/easy_localization.dart';

import 'package:group_selection/group_selection.dart' as GroupSelection show TextLocalizer;

class TextLocalizer implements GroupSelection.TextLocalizer {
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize.tr(args: args);
  }
}