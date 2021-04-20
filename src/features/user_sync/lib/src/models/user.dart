class User {
  final String userId;
  final Map<String, dynamic> data;

  User({this.userId = "", this.data = const {}});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json["userId"],
      data: Map.fromIterable(
      json.keys.where((k) => k !='userId'), key: (k) => k, value: (k) => json[k]));

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'data': data,
      };

  bool get isEmpty => userId.isEmpty && data.isEmpty;
}
