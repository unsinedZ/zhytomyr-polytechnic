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
                      .map<Widget>((weekNumber) => _SelectedFilterButton(
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
                    widget.group!.subgroups!.length > 0
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
                            .map<Widget>((subgroup) => _SelectedFilterButton(
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
                                ))
                            .toList(),
                      ),
                    ),
                  ]
                : []),
      ),
    );
  }
}

class _SelectedFilterButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback? onPressed;

  _SelectedFilterButton({
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

// class _UnselectedFilterButton extends StatelessWidget {
//   final int index;
//   final int length;
//   final String text;
//   final Function onPress;
//
//   _UnselectedFilterButton({
//     required this.index,
//     required this.length,
//     required this.text,
//     required this.onPress,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ClipRRect(
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.fromBorderSide(BorderSide(
//               width: 1.0,
//               color: Colors.black,
//             )),
//             borderRadius: index == 0
//                 ? BorderRadius.only(
//                     bottomLeft: Radius.circular(15.0),
//                     topLeft: Radius.circular(15.0))
//                 : index == length - 1
//                     ? BorderRadius.only(
//                         bottomRight: Radius.circular(15.0),
//                         topRight: Radius.circular(15.0))
//                     : BorderRadius.zero,
//           ),
//           child: OutlinedButton(
//             style: ButtonStyle(
//               // side: MaterialStateProperty.all(
//               //   BorderSide(
//               //     width: 1.0,
//               //     color: Colors.black,
//               //   ),
//               // ),
//               elevation: MaterialStateProperty.all(0),
//               minimumSize: MaterialStateProperty.all(Size.square(50)),
//               backgroundColor: MaterialStateProperty.all(Color(0xffeeeeee)),
//               shape: index == 0
//                   ? MaterialStateProperty.all(
//                       RoundedRectangleBorder(
//                         side: BorderSide(
//                           width: 1.0,
//                           color: Colors.black,
//                         ),
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(15.0),
//                             topLeft: Radius.circular(15.0)),
//                       ),
//                     )
//                   : index == length - 1
//                       ? MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(15.0),
//                                 topRight: Radius.circular(15.0)),
//                           ),
//                         )
//                       : MaterialStateProperty.all(RoundedRectangleBorder()),
//             ),
//             onPressed: () => onPress(),
//             child: Text(
//               text,
//               textScaleFactor: 1.3,
//               // style: isSelected == false
//               //     ? Theme.of(context).textTheme.headline2
//               //     : null,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
