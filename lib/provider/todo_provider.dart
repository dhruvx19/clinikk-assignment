import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoProvider with ChangeNotifier {
  List<Task> _tasks = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late SharedPreferences _prefs;

  List<Task> get tasks => _tasks;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  CalendarFormat get calendarFormat => _calendarFormat;

  TodoProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTasks();
  }

  void _loadTasks() {
    final tasksJson = _prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((task) => Task.fromJson(json.decode(task))).toList();
    notifyListeners();
  }

  void _saveTasks() {
    final tasksJson = _tasks.map((task) => json.encode(task.toJson())).toList();
    _prefs.setStringList('tasks', tasksJson);
    notifyListeners();
  }

  List<Task> getTasksForSelectedDay() {
    return _tasks.where((task) {
      return task.date.year == _selectedDay.year &&
          task.date.month == _selectedDay.month &&
          task.date.day == _selectedDay.day;
    }).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
  }

  void editTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _saveTasks();
    }
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    _saveTasks();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    _saveTasks();
  }

  void updateSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    notifyListeners();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  Color getCategoryColor(String category, BuildContext context) {
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
}