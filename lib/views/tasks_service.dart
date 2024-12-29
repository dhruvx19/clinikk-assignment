

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';

class TaskService {
  final SharedPreferences _prefs;
  List<Task> _tasks = [];
  
  TaskService(this._prefs);

  Future<void> loadTasks() async {
    final tasksJson = _prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((task) => Task.fromJson(json.decode(task))).toList();
  }

  void _saveTasks() {
    final tasksJson = _tasks.map((task) => json.encode(task.toJson())).toList();
    _prefs.setStringList('tasks', tasksJson);
  }

  List<Task> getTasksForDay(DateTime day, bool completed) {
    return _tasks.where((task) {
      return task.date.year == day.year &&
          task.date.month == day.month &&
          task.date.day == day.day &&
          task.isCompleted == completed;
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
    _tasks.removeWhere((t) => t.id == task.id);
    _saveTasks();
  }

  void updateTaskStatus(Task task, bool completed) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isCompleted = completed;
      _saveTasks();
    }
  }
}