import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/task.dart';
import '../../../providers/task_provider.dart';

class TaskDeadlineScreen extends StatelessWidget {
  final Task task;

  const TaskDeadlineScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Call your provider for the live calculation
    final taskProvider = context.read<TaskProvider>();
    final String remaining = taskProvider.calculateDeadline(task.dueDate).toString();
    final String today = DateTime.now().toString().split(' ')[0]; // Just the date part

    return Scaffold(
      appBar: AppBar(title: const Text("Deadline Details")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Time Tracking", style: TextStyle(color: Colors.grey)),
            Text(task.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            _buildInfoRow(Icons.calendar_today, "Deadline", task.dueDate.toString().split(' ')[0], Colors.redAccent),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.today, "Today", today, Colors.blueAccent),
            
            const Divider(height: 60),

            Center(
              child: Column(
                children: [
                  const Text("REMAINING TIME", style: TextStyle(letterSpacing: 1.2, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(
                    remaining,
                    style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}