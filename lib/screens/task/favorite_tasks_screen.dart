import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import 'widgets/task_item.dart';

class FavoriteTasksScreen extends StatelessWidget {
  const FavoriteTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Tasks"),
      ),
      body: provider.favoriteTasks.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: provider.favoriteTasks.length,
              itemBuilder: (context, index) {
                final task = provider.favoriteTasks[index];

                return TaskItem(
                  task: task,
                  onDelete: null,
                  onEdit: (task) {},
                );
              },
            ),
    );
  }
}