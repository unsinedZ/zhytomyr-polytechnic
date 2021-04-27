import 'dart:async';

import 'package:contacts/src/bl/abstractions/contacts_repository.dart';
import 'package:contacts/src/bl/models/contacts_data.dart';

class ContactsScreenBloc {
  final ContactsRepository contactsRepository;
  final StreamSink<String> errorSink;

  StreamController<ContactsData?> _contactsDataController =
      StreamController.broadcast();

  ContactsScreenBloc({
    required this.contactsRepository,
    required this.errorSink,
  });

  Stream<ContactsData?> get contactsData => _contactsDataController.stream;

  void loadContactsData() async {
    _contactsDataController.add(null);

    contactsRepository
        .loadContactsData()
        .then((contactsData) => _contactsDataController.add(contactsData))
        .catchError((err) {
      errorSink.add(err.toString());
      _contactsDataController.add(ContactsData.empty());
    });
  }

  void dispose() {
    _contactsDataController.close();
  }
}
