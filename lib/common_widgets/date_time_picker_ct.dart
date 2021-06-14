import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course2/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course2/common_widgets/input_dropdown.dart';

class DateTimePickerCT extends StatelessWidget {
  const DateTimePickerCT({
    Key key,
    this.labelText,
    this.selectedDateTime,
    this.onSelectedDateTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDateTime;
  final ValueChanged<DateTime> onSelectedDateTime;


  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headline6;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: InputDropdown(
            labelText: labelText,
            valueText: Format.dateTime(selectedDateTime),
            valueStyle: valueStyle,
            onPressed: () => {
              _showDemoPicker(
                context: context,
                child: _BottomPicker(
                  child: CupertinoDatePicker(
                    backgroundColor:
                        CupertinoColors.systemBackground.resolveFrom(context),
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (newDateTime) => onSelectedDateTime(newDateTime),
                  ),
                ),
              )
            },
          ),
        ),
      ],
    );
  }
}

void _showDemoPicker({
  @required BuildContext context,
  @required Widget child,
}) {
  final themeData = CupertinoTheme.of(context);
  final dialogBody = CupertinoTheme(
    data: themeData,
    child: child,
  );

  showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => dialogBody,
  );
}

class _BottomPicker extends StatelessWidget {
  const _BottomPicker({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      ),
    );
  }
}
