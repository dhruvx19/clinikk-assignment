import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/utils/addTaskDailog.dart';
import 'package:todo_app/utils/date_time_picker.dart';

class TaskDialogUtils {
  static Future<void> showTaskDialog(
    BuildContext context, {
    Task? existingTask,
  }) async {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    
    return AddTaskDialog.show(
      context,
      existingTask: existingTask,
      showDatePicker: (context) => DateTimePickerUtils.showDatePicker(
        context,
        existingTask?.date ?? todoProvider.selectedDay,
      ),
      showTimePicker: (context) => DateTimePickerUtils.showTimePicker(
        context,
        TimeOfDay.now(),
      ),
    );
  }
}