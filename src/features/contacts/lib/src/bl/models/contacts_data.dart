class ContactsData {
  final String phoneNumber;
  final String address;
  final String instagramUrl;
  final String telegramUrl;
  final String facebookUrl;

  ContactsData({
    required this.phoneNumber,
    required this.address,
    required this.instagramUrl,
    required this.telegramUrl,
    required this.facebookUrl,
  });

  factory ContactsData.fromJson(Map<String, dynamic> json) => ContactsData(
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        instagramUrl: json['instagramUrl'],
        telegramUrl: json['telegramUrl'],
        facebookUrl: json['facebookUrl'],
      );

  factory ContactsData.empty() => ContactsData(
        phoneNumber: '',
        address: '',
        instagramUrl: '',
        telegramUrl: '',
        facebookUrl: '',
      );
}
