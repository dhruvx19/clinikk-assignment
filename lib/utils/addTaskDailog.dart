import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/provider/todo_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? existingTask;
  final Function(BuildContext) showDatePicker;
  final Function(BuildContext) showTimePicker;

  const AddTaskDialog({
    Key? key,
    this.existingTask,
    required this.showDatePicker,
    required this.showTimePicker,
  }) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();

  static Future<void> show(
    BuildContext context, {
    Task? existingTask,
    required Function(BuildContext) showDatePicker,
    required Function(BuildContext) showTimePicker,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        existingTask: existingTask,
        showDatePicker: showDatePicker,
        showTimePicker: showTimePicker,
      ),
    );
  }
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.existingTask?.title ?? '');
    descriptionController = TextEditingController(text: widget.existingTask?.description ?? '');
    selectedCategory = widget.existingTask?.category ?? 'Work';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final isEditing = widget.existingTask != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
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
                  setState(() {
                    selectedCategory = value!;
                  });
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
            if (titleController.text.trim().isEmpty) {
              todoProvider.showToast('Please enter a title');
              return;
            }
            if (descriptionController.text.trim().isEmpty) {
              todoProvider.showToast('Please enter a description');
              return;
            }

            final DateTime? selectedDate = await widget.showDatePicker(
              context,
            );

            if (selectedDate != null) {
              final TimeOfDay? selectedTime = await widget.showTimePicker(context);

              if (selectedTime != null) {
                final DateTime taskDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final task = Task(
                  id: widget.existingTask?.id ?? DateTime.now().toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  date: taskDateTime,
                  category: selectedCategory,
                  time: selectedTime,
                  isCompleted: widget.existingTask?.isCompleted ?? false,
                );

                if (isEditing) {
                  todoProvider.editTask(task);
                } else {
                  todoProvider.addTask(task);
                }
                Navigator.pop(context);
              }
            }
          },
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}