import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task.dart';
import '../../../services/task_service.dart';

Future<void> showTaskForm({
  required BuildContext context,
  Task? task,
  required TaskService service,
}) async {
  final titleController = TextEditingController(text: task?.title ?? '');
  final descController = TextEditingController(text: task?.description ?? '');

  String selectedPriority = task?.priority ?? 'High';
  DateTime selectedDate = task?.dueDate ?? DateTime.now();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateSheet) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(  // title input
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),

                TextField(  // description input
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),

                ListTile(  // date picker
                  title: Text(
                    "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),  
                    );

                    if (picked != null) {
                      setStateSheet(() => selectedDate = picked);  // store date
                    }
                  },
                ),

                DropdownButton<String>(  // priority dropdown list
                  value: selectedPriority,
                  items: ['Low', 'Medium', 'High']
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setStateSheet(() => selectedPriority = val!);
                  },
                ),

                ElevatedButton(  // add/update button
                  onPressed: () async {
                    final taskObj = Task(
                      id: task?.id,
                      title: titleController.text,
                      description: descController.text,
                      priority: selectedPriority,
                      dueDate: selectedDate,
                    );

                    if (task == null) {
                      await service.addTask(taskObj);
                    } else {
                      await service.updateTask(taskObj);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(task == null ? "Add Task" : "Update Task"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}