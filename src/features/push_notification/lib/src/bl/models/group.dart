class Group {
  final String groupId;
  final String subgroupId;

  Group({
    required this.groupId,
    required this.subgroupId,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json['groupId'],
        subgroupId: json['subgroupId'],
      );

  String get toTopic =>
      "group." + groupId + (subgroupId.isNotEmpty ? "." + subgroupId : "");
}
