import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/views/widgets/time_picker.dart';

class DateTimePickerUtils {
  static Future<DateTime?> showDatePicker(
      BuildContext context, DateTime initialDate) async {
    return showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = initialDate;
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 360,
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: selectedDate,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                    onDaySelected: (selected, focused) {
                      selectedDate = selected;
                      Navigator.pop(context, selected);
                    },
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<TimeOfDay?> showTimePicker(BuildContext context, TimeOfDay initialTime) async {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        TimeOfDay selectedTime = initialTime;
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: TimePickerSpinner(
                    time: DateTime.now().copyWith(
                      hour: selectedTime.hour,
                      minute: selectedTime.minute,
                    ),
                    onTimeChange: (DateTime dateTime) {
                      selectedTime = TimeOfDay.fromDateTime(dateTime);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, selectedTime),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}