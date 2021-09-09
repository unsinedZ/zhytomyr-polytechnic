class SocialNetwork {
  final String label;
  final String name;
  final String url;

  SocialNetwork({
    required this.label,
    required this.name,
    required this.url,
  });

  factory SocialNetwork.fromJson(Map<String, dynamic> json) => SocialNetwork(
    label: json['label'],
    name: json['name'],
    url: json['url'],
  );
}
