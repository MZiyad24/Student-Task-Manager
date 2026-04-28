import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repos/TaskRepository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String _errorMessage = "";

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  
  Future<void> fetchTasks() async {
    _setLoading(true);
    _errorMessage = "";
    
    try {
      _tasks = await _taskRepo.getTasks();
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _tasks = []; 
    } finally {
      _setLoading(false);
    }
  }

  // 2. Add a Task
  Future<bool> addTask(Task task) async {
    _setLoading(true);
    try {
      await _taskRepo.insertTask(task);
      await fetchTasks(); // Refresh list from server
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // 3. Update a Task (e.g., toggling completion)
  Future<void> updateTask(Task task) async {
    try {
      await _taskRepo.updateTask(task);
      int index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 4. Delete a Task
  Future<void> removeTask(String id) async {
    try {
      await _taskRepo.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}