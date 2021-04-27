import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:contacts/src/bl/models/contacts_data.dart';

void main() {
  test('ContactsData.fromJson work correctly', () {
    final ContactsData contactsData = ContactsData.fromJson(jsonDecode(
        '{"phoneNumber" : "phoneNumber", '
          '"address" : "address", '
          '"instagramUrl" : "instagramUrl", '
          '"telegramUrl" : "telegramUrl", '
          '"facebookUrl" : "facebookUrl"'
        '}'));

    expect(contactsData.phoneNumber, "phoneNumber");
    expect(contactsData.address, "address");
    expect(contactsData.instagramUrl, "instagramUrl");
    expect(contactsData.telegramUrl, "telegramUrl");
    expect(contactsData.facebookUrl, "facebookUrl");
  });
}
