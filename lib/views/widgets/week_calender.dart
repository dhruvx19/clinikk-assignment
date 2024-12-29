import 'package:flutter/material.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  List<DateTime> _getDaysInWeek(DateTime date) {
    final firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(
        7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final week = _getDaysInWeek(selectedDate);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () => onDateSelected(
                  selectedDate.subtract(Duration(days: 7)),
                ),
              ),
              Text(
                'FEBRUARY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' 2022',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => onDateSelected(
                  selectedDate.add(Duration(days: 7)),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: week.map((date) {
            final isSelected = date.day == selectedDate.day;
            final isWeekend = date.weekday == DateTime.sunday ||
                date.weekday == DateTime.saturday;

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF7B68EE) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      [
                        'SUN',
                        'MON',
                        'TUE',
                        'WED',
                        'THU',
                        'FRI',
                        'SAT'
                      ][date.weekday - 1],
                      style: TextStyle(
                        fontSize: 12,
                        color: isWeekend ? Colors.red : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? Colors.white
                            : isWeekend
                                ? Colors.red
                                : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
