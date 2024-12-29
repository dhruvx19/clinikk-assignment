import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/views/widgets/time_picker.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Task> tasks = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late SharedPreferences prefs;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _loadTasks();
  }

  void _loadTasks() {
    final tasksJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks =
          tasksJson.map((task) => Task.fromJson(json.decode(task))).toList();
    });
  }

  void _saveTasks() {
    final tasksJson = tasks.map((task) => json.encode(task.toJson())).toList();
    prefs.setStringList('tasks', tasksJson);
  }

  List<Task> _getTasksForSelectedDay() {
    return tasks.where((task) {
      return task.date.year == _selectedDay.year &&
          task.date.month == _selectedDay.month &&
          task.date.day == _selectedDay.day;
    }).toList();
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      _saveTasks();
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  void _editTask(Task task) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        _saveTasks();
      }
    });
  }

  Future<DateTime?> _showDatePicker(
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
                Container(
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

  Future<TimeOfDay?> _showTimePicker(BuildContext context) async {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        TimeOfDay selectedTime = _selectedTime;
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

// Custom Time Picker Spinner Widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
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
                  outsideDaysVisible: false,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  headerPadding: EdgeInsets.symmetric(vertical: 0),
                  leftChevronIcon: Icon(Icons.chevron_left, size: 28),
                  rightChevronIcon: Icon(Icons.chevron_right, size: 28),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Today'),
                  Tab(text: 'Completed'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(false),
          _buildTaskList(true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildTaskList(bool showCompleted) {
    final filteredTasks = _getTasksForSelectedDay()
        .where((task) => task.isCompleted == showCompleted)
        .toList();

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              boxShadow: Theme.of(context).brightness == Brightness.light
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    task.isCompleted = value ?? false;
                    _saveTasks();
                  });
                },
              ),
              title: Text(task.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(task.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.category,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${task.time.hour.toString().padLeft(2, '0')}:${task.time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showTaskDialog(context, existingTask: task),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        tasks.remove(task);
                        _saveTasks();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.amber.withOpacity(0.7);
      case 'home':
        return Colors.red.withOpacity(0.7);
      case 'university':
        return Theme.of(context).primaryColor.withOpacity(0.7);
      default:
        return Colors.grey.withOpacity(0.7);
    }
  }

  Future<void> _showTaskDialog(BuildContext context,
      {Task? existingTask}) async {
    final titleController =
        TextEditingController(text: existingTask?.title ?? '');
    final descriptionController =
        TextEditingController(text: existingTask?.description ?? '');
    String selectedCategory = existingTask?.category ?? 'Work';
    final isEditing = existingTask != null;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'Add Task'),
          content: ConstrainedBox(
            constraints:
                const BoxConstraints(maxHeight: 400), // Prevent overflow
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: ['Work', 'Home', 'University']
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedCategory = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Validation check
                if (titleController.text.trim().isEmpty) {
                  _showToast('Please enter a title');
                  return;
                }
                if (descriptionController.text.trim().isEmpty) {
                  _showToast('Please enter a description');
                  return;
                }

                final DateTime? selectedDate = await _showDatePicker(
                  context,
                  isEditing ? existingTask!.date : _selectedDay,
                );

                if (selectedDate != null) {
                  final TimeOfDay? selectedTime =
                      await _showTimePicker(context);

                  if (selectedTime != null) {
                    final DateTime taskDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final task = Task(
                      id: existingTask?.id ?? DateTime.now().toString(),
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      date: taskDateTime,
                      category: selectedCategory,
                      time: selectedTime,
                      isCompleted: existingTask?.isCompleted ?? false,
                    );

                    if (isEditing) {
                      _editTask(task);
                    } else {
                      _addTask(task);
                    }
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
