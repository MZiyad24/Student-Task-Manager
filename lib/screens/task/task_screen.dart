import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';
import 'widgets/task_list.dart';
import 'widgets/task_form.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskService service = TaskService();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  bool isLoading = true; // 1. Add a loading flag

  Future<void> loadTasks() async {
    setState(() => isLoading = true);
    final data = await service.getAllTasks();
    setState(() {
      tasks = data;
      isLoading = false; // 2. Turn off loading
    });
  }

  Future<void> deleteTask(String id) async {
    await service.deleteTask(id);
    loadTasks();
  }

  void openForm({Task? task}) async {
    await showTaskForm(context: context, task: task, service: service);

    loadTasks(); // refresh after add/update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Tasks"),
        backgroundColor: Colors.grey[200],
        elevation: 1,
        actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.blue),
          tooltip: 'Profile',
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TaskList(
              tasks: tasks,
              onDelete: deleteTask,
              onEdit: (task) => openForm(task: task),
            ),
    );
  }
}
