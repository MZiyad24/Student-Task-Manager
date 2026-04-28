import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskForm({super.key, this.task, required this.onSave});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedPriority;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _selectedPriority = widget.task?.priority ?? 'High';
    _selectedDate = widget.task?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Handles keyboard overlap automatically
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20, left: 20, right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Task Details", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text("Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
            leading: const Icon(Icons.calendar_month, color: Colors.blue),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            decoration: const InputDecoration(labelText: "Priority"),
            items: ['Low', 'Medium', 'High']
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (val) => setState(() => _selectedPriority = val!),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                final taskObj = Task(
                  id: widget.task?.id,
                  title: _titleController.text,
                  description: _descController.text,
                  priority: _selectedPriority,
                  dueDate: _selectedDate,
                );
                widget.onSave(taskObj);
              },
              child: Text(
                widget.task == null ? "Add Task" : "Update Task",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}