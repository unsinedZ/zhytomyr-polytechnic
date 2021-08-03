import 'package:flutter/material.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:update_form/src/bl/models/group.dart';

class GroupsMultiSelect extends StatelessWidget {
  final List<MultiSelectItem<Group?>> items;
  final List<Group> selectedGroups;
  final void Function(List<Group?>) onConfirm;
  final void Function(Group) removeGroup;

  GroupsMultiSelect({
    required this.items,
    required this.selectedGroups,
    required this.onConfirm,
    required this.removeGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          key: Key(selectedGroups.join('/')),
          padding: const EdgeInsets.all(8.0),
          child: MultiSelectDialogField<Group?>(
            items: items,
            listType: MultiSelectListType.CHIP,
            onConfirm: onConfirm,
            chipDisplay: MultiSelectChipDisplay.none(),
            initialValue: selectedGroups,
            searchable: true,
            buttonText: Text('Вибрати групи'),
            buttonIcon: Icon(
              Icons.arrow_downward,
              color: Colors.black,
            ),
            searchIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            closeSearchIcon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Виберіть мінімум 1 групу';
            },
          ),
        ),
        MultiSelectChipDisplay<Group?>(
          items: selectedGroups
              .map((group) => MultiSelectItem(
                  group,
                  group.name +
                      (group.subgroups.isNotEmpty
                          ? ('(' + group.subgroups.first.name + ')')
                          : '')))
              .toList(),
          height: 50,
          onTap: (value) {
            Group group = selectedGroups
                .firstWhere((group) => group == (value as Group));
            removeGroup(group);
          },
        ),
      ],
    );
  }
}
