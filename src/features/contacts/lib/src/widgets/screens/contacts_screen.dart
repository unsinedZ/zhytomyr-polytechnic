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
  final Widget Function({required Widget child}) bodyWrapper;

  ContactsScreen({
    required this.textLocalizer,
    required this.contactsRepository,
    required this.errorSink,
    required this.bodyWrapper,
  });

  @override
  Widget build(BuildContext context) {
    ContactsScreenBloc contactsScreenBloc = ContactsScreenBloc(
      contactsRepository: contactsRepository,
      errorSink: errorSink,
    );

    contactsScreenBloc.loadContactsData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          textLocalizer.localize("Contacts"),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: bodyWrapper(
        child: StreamBuilder<ContactsData?>(
            stream: contactsScreenBloc.contactsData,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return ContactsScreenShimmer();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrefixedContainer(
                    title: textLocalizer.localize("Number"),
                    text: snapshot.data!.phoneNumber,
                    onTap: () =>
                        _launchURL("tel:${snapshot.data!.phoneNumber}"),
                  ),
                  PrefixedContainer(
                    title: textLocalizer.localize("Address"),
                    text: snapshot.data!.address,
                    onTap: () => _launchURL(snapshot.data!.addressUrl),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ...snapshot.data!.socialNetworks.map(
                    (socialNetwork) {
                      IconData iconData;

                      switch (socialNetwork.name) {
                        case 'instagram':
                          iconData = FontAwesomeIcons.instagram;
                          break;
                        case 'telegram' :
                            iconData = FontAwesomeIcons.telegram;
                            break;
                        case 'facebook' :
                          iconData = FontAwesomeIcons.facebook;
                          break;
                        default :
                          iconData = FontAwesomeIcons.globeEurope;
                          break;
                      }

                      return SocialNetworkContainer(
                        icon: FaIcon(
                          iconData,
                          color: Theme.of(context).primaryColor,
                        ),
                        text: socialNetwork.label,
                        onTap: () => _launchURL(socialNetwork.url),
                      );
                    },
                  ).toList(),
                ],
              );
            }),
      ),
    );
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
