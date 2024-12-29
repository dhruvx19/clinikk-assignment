// task_model.dart
import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  String category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute},
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['time']['hour'],
        minute: json['time']['minute'],
      ),
      category: json['category'],
      isCompleted: json['isCompleted'],
    );
  }
}


class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    userId: json['userId'],
    title: json['title'],
    body: json['body'],
    id: json['id'],
  );
}
