import 'package:flutter/material.dart';
import '../../../models/task.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) onDelete;
  final Function(Task) onEdit;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks"));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onDelete: onDelete,
          onEdit: onEdit,
        );
      },
    );
  }
}