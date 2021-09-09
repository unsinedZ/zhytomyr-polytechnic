import 'dart:async';

import 'package:contacts/src/bl/models/contacts_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:contacts/src/bl/abstractions/contacts_repository.dart';
import 'package:contacts/src/bl/bloc/contacts_screen_bloc.dart';

class ContactsRepositoryMock extends Mock implements ContactsRepository {
  @override
  Future<ContactsData> loadContactsData() => super.noSuchMethod(
        Invocation.method(#loadContactsData, []),
        returnValue: Future.value(
          ContactsData(
            address: '',
            phoneNumber: '',
            addressUrl: '',
            socialNetworks: [],
          ),
        ),
      );
}

void main() {
  test("ContactsScreenBloc work correctly", () async {
    ContactsRepositoryMock contactsRepositoryMock = ContactsRepositoryMock();

    ContactsScreenBloc contactsScreenBloc = ContactsScreenBloc(
      contactsRepository: contactsRepositoryMock,
      errorSink: StreamController<String>().sink,
    );

    when(contactsRepositoryMock.loadContactsData()).thenAnswer(
      (_) => Future.value(
        ContactsData(
          phoneNumber: 'phoneNumber',
          address: 'address',
          addressUrl: 'addressUrl',
          socialNetworks: [],
        ),
      ),
    );

    List<ContactsData?> results = <ContactsData?>[];

    contactsScreenBloc.contactsData
        .listen((contactsData) => results.add(contactsData));
    contactsScreenBloc.loadContactsData();

    await Future.delayed(const Duration());

    expect(results[0], null);
    expect(results.length, 2);
    expect(results[1]!.address, 'address');
    expect(results[1]!.addressUrl, 'addressUrl');
    expect(results[1]!.phoneNumber, 'phoneNumber');
  });
}
