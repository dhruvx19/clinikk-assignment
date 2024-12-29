import 'package:flutter/material.dart';

class TimePickerSpinner extends StatefulWidget {
  final DateTime time;
  final Function(DateTime) onTimeChange;

  const TimePickerSpinner({
    Key? key,
    required this.time,
    required this.onTimeChange,
  }) : super(key: key);

  @override
  _TimePickerSpinnerState createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  late int _selectedHour;
  late int _selectedMinute;
  late bool _isAM;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.time.hour;
    _selectedMinute = widget.time.minute;
    _isAM = widget.time.hour < 12;
    if (_selectedHour > 12) _selectedHour -= 12;
    if (_selectedHour == 0) _selectedHour = 12;
  }

  void _updateTime() {
    int hour = _selectedHour;
    if (!_isAM && hour != 12) hour += 12;
    if (_isAM && hour == 12) hour = 0;
    
    final newTime = DateTime(
      widget.time.year,
      widget.time.month,
      widget.time.day,
      hour,
      _selectedMinute,
    );
    widget.onTimeChange(newTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hours
        Expanded(
          child: ListWheelScrollView(
            itemExtent: 50,
            diameterRatio: 1.5,
            children: List.generate(12, (index) {
              final hour = index + 1;
              return Center(
                child: Text(
                  hour.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 20,
                    color: _selectedHour == hour
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              );
            }),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedHour = index + 1;
                _updateTime();
              });
            },
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        // Minutes
        Expanded(
          child: ListWheelScrollView(
            itemExtent: 50,
            diameterRatio: 1.5,
            children: List.generate(60, (index) {
              return Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 20,
                    color: _selectedMinute == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              );
            }),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMinute = index;
                _updateTime();
              });
            },
          ),
        ),
        // AM/PM
        Expanded(
          child: ListWheelScrollView(
            itemExtent: 50,
            diameterRatio: 1.5,
            children: ['AM', 'PM'].map((period) {
              return Center(
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 20,
                    color: (_isAM && period == 'AM') || (!_isAM && period == 'PM')
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              );
            }).toList(),
            onSelectedItemChanged: (index) {
              setState(() {
                _isAM = index == 0;
                _updateTime();
              });
            },
          ),
        ),
      ],
    );
  }
}