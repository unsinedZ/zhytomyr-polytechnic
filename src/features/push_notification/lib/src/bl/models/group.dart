class Group {
  final String groupId;
  final String subgroupId;

  Group({
    required this.groupId,
    required this.subgroupId,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json['groupId'].toString(),
        subgroupId: json['subgroupId'].toString(),
      );

  String get toTopic =>
      "group." + groupId + (subgroupId.isNotEmpty ? "." + subgroupId : "");
}
