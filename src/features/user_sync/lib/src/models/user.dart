class User {
  final String userId;
  final AuthProvider authProvider;
  final Map<String, dynamic> data;

  User({
    required this.userId,
    required this.authProvider,
    required this.data,
  });

  factory User.fromJson(Map<String, dynamic> json, AuthProvider authProvider) => User(
        userId: json["userId"] ?? '',
        authProvider: authProvider,
        data: Map.fromIterable(json.keys.where((k) => k != 'userId'),
            key: (k) => k, value: (k) => json[k]),
      );

  factory User.fromStorage(Map<String, dynamic> json) => User(
        userId: json["userId"],
        authProvider: authProviderFromString(json["authProvider"]),
        data: json["data"],
      );

  factory User.empty() => User(
        userId: "",
        authProvider: AuthProvider.Empty,
        data: {},
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'authProvider': authProvider.toString().split(".").last,
        'data': data,
      };

  bool get isEmpty => userId.isEmpty && data.isEmpty;
}

enum AuthProvider {
  Google,
  Facebook,
  Empty
}

AuthProvider authProviderFromString(String value){
  return AuthProvider.values.firstWhere(
          (e) =>
      e.toString().split(".").last.toLowerCase() == value.toLowerCase(),
      orElse: () => AuthProvider.Empty);
}
