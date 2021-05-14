class Version {
  final String os;
  final String version;
  final String url;

  Version({
    required this.os,
    required this.version,
    required this.url,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    os: json['os'],
    version: json['version'],
    url: json['url'],
  );
}
