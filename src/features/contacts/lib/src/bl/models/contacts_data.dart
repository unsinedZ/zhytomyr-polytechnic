import 'package:contacts/src/bl/models/social_network.dart';

class ContactsData {
  final String phoneNumber;
  final String address;
  final String addressUrl;
  final List<SocialNetwork> socialNetworks;

  ContactsData({
    required this.phoneNumber,
    required this.address,
    required this.addressUrl,
    required this.socialNetworks,
  });

  factory ContactsData.fromJson(Map<String, dynamic> json) => ContactsData(
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        addressUrl: json['addressUrl'],
        socialNetworks: (json['socialNetworks'] as List<dynamic>)
            .map((json) => SocialNetwork.fromJson(json))
            .toList(),
      );

  factory ContactsData.empty() => ContactsData(
        phoneNumber: '',
        address: '',
        addressUrl: '',
        socialNetworks: [],
      );
}
