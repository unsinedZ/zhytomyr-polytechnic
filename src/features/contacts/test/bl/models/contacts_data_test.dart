import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:contacts/src/bl/models/contacts_data.dart';

void main() {
  test('ContactsData.fromJson work correctly', () {
    final ContactsData contactsData = ContactsData.fromJson(jsonDecode(
        '{"phoneNumber" : "phoneNumber", '
          '"address" : "address", '
          '"socialNetworks" : [], '
          '"addressUrl" : "addressUrl"'
        '}'));

    expect(contactsData.phoneNumber, "phoneNumber");
    expect(contactsData.address, "address");
    expect(contactsData.addressUrl, "addressUrl");
  });
}
