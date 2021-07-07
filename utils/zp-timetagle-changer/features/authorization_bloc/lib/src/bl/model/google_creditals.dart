class GoogleCreditals {
  final String projectId;
  final String privateKeyId;
  final String privateKey;
  final String clientEmail;
  final String clientId;

  GoogleCreditals({
    required this.projectId,
    required this.privateKeyId,
    required this.privateKey,
    required this.clientEmail,
    required this.clientId,
  });

  factory GoogleCreditals.fromJson(Map<String, dynamic> json) => GoogleCreditals(
        projectId: json['project_id'],
        privateKeyId: json['private_key_id'],
        privateKey: json['private_key'],
        clientEmail: json['client_email'],
        clientId: json['client_id'],
      );
}
