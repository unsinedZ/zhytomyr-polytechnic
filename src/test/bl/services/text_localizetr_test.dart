import 'package:flutter_test/flutter_test.dart';

import 'package:zhytomyr_polytechnic/bl/services/text_localizer.dart';

void main() {
  test("TextLocalizer work correctly", () {
    final TextLocalizer textLocalizer = TextLocalizer();
    expect(textLocalizer.localize('stringToLocalize'), 'stringToLocalize');
  });
}
