import 'package:group_selection/group_selection.dart' as GroupSelection show TextLocalizer;

class TextLocalizer implements GroupSelection.TextLocalizer {
  String localize(String stringToLocalize, [List<String>? args]) {
    return stringToLocalize;
  }
}