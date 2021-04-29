class UserData {
  final Map<String, dynamic> data;

  UserData({
    required this.data,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        data: json,
      );
}
