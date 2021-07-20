class User {
  final String userId;
  final AuthProvider authProvider;
  final String groupId;
  final String subgroupId;

  User({
    required this.userId,
    required this.authProvider,
    required this.groupId,
    required this.subgroupId,
  });

  factory User.fromJson(Map<String, dynamic> json, AuthProvider authProvider) =>
      User(
        userId: json["userId"] ?? '',
        authProvider: authProvider,
        groupId: json["groupId"],
        subgroupId: json["subgroupId"],
      );

  factory User.fromStorage(Map<String, dynamic> json) => User(
        userId: json["userId"],
        authProvider: authProviderFromString(json["authProvider"]),
        groupId: json["groupId"],
        subgroupId: json["subgroupId"],
      );

  factory User.empty() => User(
        userId: "",
        authProvider: AuthProvider.Empty,
        groupId: '',
        subgroupId: '',
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'authProvider': authProvider.toString().split(".").last,
        'groupId': groupId,
        'subgroupId': subgroupId,
      };

  bool get isEmpty => userId.isEmpty;
}

enum AuthProvider { Google, Facebook, Apple, Empty }

AuthProvider authProviderFromString(String value) {
  return AuthProvider.values.firstWhere(
      (e) => e.toString().split(".").last.toLowerCase() == value.toLowerCase(),
      orElse: () => AuthProvider.Empty);
}
