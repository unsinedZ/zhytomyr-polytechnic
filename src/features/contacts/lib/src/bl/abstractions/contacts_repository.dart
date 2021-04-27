import 'dart:async';

import 'package:contacts/src/bl/models/contacts_data.dart';

abstract class ContactsRepository {
  Future<ContactsData> loadContactsData();
}