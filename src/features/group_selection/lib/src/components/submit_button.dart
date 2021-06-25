import 'package:flutter/material.dart';
import 'package:group_selection/src/bl/models/models.dart';

class SubmitButton extends StatelessWidget {
  final int? course;
  final Group? group;
  final Subgroup? subgroup;
  final bool isMyGroup;
  final String text;
  final ValueChanged<Map<String, dynamic>> subscribeCallback;

  SubmitButton({
    required this.course,
    required this.group,
    required this.subgroup,
    required this.isMyGroup,
    required this.text,
    required this.subscribeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: course == null ||
                group == null ||
                (group!.subgroups != null &&
                    group!.subgroups!.length > 0 &&
                    subgroup == null)
            ? null
            : () {
                if (isMyGroup) {
                  subscribeCallback({
                    "groupId": group!.id,
                    "subgroupId": subgroup == null ? "" : subgroup!.id
                  });
                }

                Navigator.pushNamed(context, '/timetable', arguments: {
                  'type': 'group',
                  'groupId': group!.id,
                  'subgroupId': subgroup == null ? null : subgroup!.id
                });
              },
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Text(
            text,
            textScaleFactor: 1.3,
          ),
        ),
      ),
    );
  }
}
