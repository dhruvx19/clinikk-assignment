// lib/screens/todo/widgets/time_display.dart

import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final TimeOfDay time;

  const TimeDisplay({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[400],
      ),
    );
  }
}