import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/task.dart';
import '../../../providers/task_provider.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String)? onDelete; // nullable
  final Function(Task) onEdit;

  const TaskItem({
    super.key,
    required this.task,
    this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
          "${task.priority} • ${DateFormat('yyyy-MM-dd').format(task.dueDate)} • ${task.isCompleted ? "Completed" : "Pending"}",
        ),

        onTap: () => onEdit(task),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  Favorite button
            IconButton(
              icon: Icon(
                task.isFavorite
                   ? Icons.favorite
                      : Icons.favorite_border,
                   color: Colors.red,
              ),
              onPressed: () {
                provider.toggleFavorite(task);
              },
            ),

            // 🗑️ Delete button (only if available)
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete!(task.id!),
              ),
          ],
        ),
      ),
    );
  }
}