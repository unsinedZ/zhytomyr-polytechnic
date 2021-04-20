class Group {
  final String group;
  final String subgroup;

  Group({required this.group, required this.subgroup});

  factory Group.fromJson(Map<String, dynamic> json) =>
      Group(group: json['group'], subgroup: json['subgroup']);

  String get toTopic => "group.{$group}.{$subgroup}";
  
}
