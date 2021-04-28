import 'dart:async';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:contacts/src/bl/abstractions/text_localizer.dart';
import 'package:contacts/src/bl/abstractions/contacts_repository.dart';
import 'package:contacts/src/bl/models/contacts_data.dart';
import 'package:contacts/src/widgets/components/contacts_screen_shimmer.dart';
import 'package:contacts/src/widgets/components/prefixed_container.dart';
import 'package:contacts/src/widgets/components/social_network_container.dart';
import 'package:contacts/src/bl/bloc/contacts_screen_bloc.dart';

class ContactsScreen extends StatelessWidget {
  final TextLocalizer textLocalizer;
  final ContactsRepository contactsRepository;
  final StreamSink<String> errorSink;

  ContactsScreen(
      {required this.textLocalizer,
      required this.contactsRepository,
      required this.errorSink});

  @override
  Widget build(BuildContext context) {
    ContactsScreenBloc contactsScreenBloc = ContactsScreenBloc(
      contactsRepository: contactsRepository,
      errorSink: errorSink,
    );

    contactsScreenBloc.loadContactsData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          textLocalizer.localize("Contacts"),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: StreamBuilder<ContactsData?>(
          stream: contactsScreenBloc.contactsData,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrefixedContainer(
                    title: textLocalizer.localize("Number"),
                    text: snapshot.data!.phoneNumber,
                    onTap: () => _launchURL("tel:${snapshot.data!.phoneNumber}"),
                  ),
                  PrefixedContainer(
                    title: textLocalizer.localize("Address"),
                    text: snapshot.data!.address,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SocialNetworkContainer(
                    icon: FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Theme.of(context).primaryColor,
                    ),
                    text: "@instagram",
                    onTap: () => _launchURL(snapshot.data!.instagramUrl),
                  ),
                  SocialNetworkContainer(
                    icon: FaIcon(
                      FontAwesomeIcons.telegram,
                      color: Theme.of(context).primaryColor,
                    ),
                    text: "@telegram",
                    onTap: () => _launchURL(snapshot.data!.telegramUrl),
                  ),
                  SocialNetworkContainer(
                    icon: FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Theme.of(context).primaryColor,
                    ),
                    text: "@facebook",
                    onTap: () => _launchURL(snapshot.data!.facebookUrl),
                  ),
                ],
              );
            } else
              return ContactsScreenShimmer();
          }),
    );
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
