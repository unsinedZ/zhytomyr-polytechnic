import 'package:flutter/material.dart';

import 'package:timetable/src/bl/abstractions/text_localizer.dart';
import 'package:timetable/src/widgets/timetable_screen.dart';
import 'package:timetable/src/bl/models/models.dart';

class FiltersBottomSheet extends StatefulWidget {
  final TextLocalizer textLocalizer;
  final int currentWeekNumber;
  final String? currentSubgroupId;
  final TimetableType timetableType;
  final Group? group;
  final Function(int) onCurrentWeekChanged;
  final Function(String) onCurrentSubgroupChanged;

  FiltersBottomSheet({
    required this.textLocalizer,
    required this.currentWeekNumber,
    required this.currentSubgroupId,
    required this.timetableType,
    required this.group,
    required this.onCurrentWeekChanged,
    required this.onCurrentSubgroupChanged,
  });

  @override
  _FiltersBottomSheetState createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  final _weekNumbers = [1, 2];

  late int currentWeekNumber;
  late String? currentSubgroupId;

  @override
  void initState() {
    currentWeekNumber = widget.currentWeekNumber;
    currentSubgroupId = widget.currentSubgroupId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
              Text(
                widget.textLocalizer.localize('Week'),
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Row(
                  children: _weekNumbers
                      .map<Widget>((weekNumber) => _FilterButton(
                            onPressed: currentWeekNumber == weekNumber
                                ? null
                                : () {
                                    setState(() {
                                      currentWeekNumber = weekNumber;
                                    });
                                    widget.onCurrentWeekChanged(weekNumber);
                                  },
                            text: weekNumber.toString(),
                            isSelected: currentWeekNumber == weekNumber,
                          ))
                      .toList(),
                ),
              ),
            ] +
            (widget.timetableType == TimetableType.Group &&
                    widget.group!.subgroups != null &&
                    widget.group!.subgroups!.isNotEmpty
                ? [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.textLocalizer.localize('Subgroup'),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.group!.subgroups!
                            .map<Widget>(
                              (subgroup) => _FilterButton(
                                onPressed: currentSubgroupId == subgroup.id
                                    ? null
                                    : () {
                                        setState(() {
                                          currentSubgroupId = subgroup.id;
                                        });
                                        widget.onCurrentSubgroupChanged(
                                            subgroup.id);
                                      },
                                text: subgroup.name,
                                isSelected: currentSubgroupId == subgroup.id,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ]
                : []),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback? onPressed;

  _FilterButton({
    required this.isSelected,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(isSelected == true
              ? Theme.of(context).focusColor
              : Theme.of(context).disabledColor),
          elevation: MaterialStateProperty.all(0),
          minimumSize: MaterialStateProperty.all(Size.square(50)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textScaleFactor: 1.3,
        ),
      ),
    );
  }
}
