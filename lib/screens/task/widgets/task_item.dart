import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onDelete;
  final Function(Task) onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
          "${task.priority} • ${DateFormat('yyyy-MM-dd').format(task.dueDate)}",
        ),

        onTap: () => onEdit(task),

        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(task.id!),
        ),
      ),
    );
  }
}