class User {
  final String userId;
  final Map<String, dynamic> data;

  User({
    required this.userId,
    required this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        data: Map.fromIterable(json.keys.where((k) => k != 'userId'),
            key: (k) => k, value: (k) => json[k]),
      );

  factory User.fromStorage(Map<String, dynamic> json) => User(
        userId: json["userId"],
        data: json["data"],
      );

  factory User.empty() => User(
        userId: "",
        data: {},
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'data': data,
      };


  bool get isEmpty => userId.isEmpty && data.isEmpty;
}
