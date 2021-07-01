class ContactsData {
  final String phoneNumber;
  final String address;
  final String addressUrl;
  final String instagramUrl;
  final String telegramUrl;
  final String facebookUrl;

  ContactsData({
    required this.phoneNumber,
    required this.address,
    required this.addressUrl,
    required this.instagramUrl,
    required this.telegramUrl,
    required this.facebookUrl,
  });

  factory ContactsData.fromJson(Map<String, dynamic> json) => ContactsData(
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        addressUrl: json['addressUrl'],
        instagramUrl: json['instagramUrl'],
        telegramUrl: json['telegramUrl'],
        facebookUrl: json['facebookUrl'],
      );

  factory ContactsData.empty() => ContactsData(
        phoneNumber: '',
        address: '',
        addressUrl: '',
        instagramUrl: '',
        telegramUrl: '',
        facebookUrl: '',
      );
}
