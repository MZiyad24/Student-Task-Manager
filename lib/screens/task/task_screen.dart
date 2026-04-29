import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Professional state management
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import 'widgets/task_list.dart';
import 'widgets/task_form.dart';
import 'task_deadlines_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks immediately when the screen loads
    Future.microtask(() => context.read<TaskProvider>().fetchTasks());
  }

  void _openForm({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskForm(
        task: task,
        onSave: (newTask) async {
          final provider = context.read<TaskProvider>();
          bool success;

          if (task == null) {
            success = await provider.addTask(newTask);
          } else {
            await provider.updateTask(newTask);
            success = true;
          }

          if (success && mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Tasks synced with cloud")),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Tasks"),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time_filled, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskListScreen()),
              );
            },
          ),
          //  Favorites Button 
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),

          // 👤 Profile Button
          IconButton(
            icon: const Icon(Icons.person, color: Colors.blue),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => taskProvider.fetchTasks(),
              child: taskProvider.tasks.isEmpty
                  ? _buildEmptyState()
                  : TaskList(
                      tasks: taskProvider.tasks,
                      onDelete: (id) => taskProvider.removeTask(id),
                      onEdit: (task) => _openForm(task: task),
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        const Center(
          child: Column(
            children: [
              Icon(Icons.task_alt, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text("No tasks yet. Tap + to start!"),
            ],
          ),
        ),
      ],
    );
  }
}