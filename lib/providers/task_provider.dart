import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repos/TaskRepository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepo = TaskRepository();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String _errorMessage = "";

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

  Future<bool> addTask(Task task) async {
    _setLoading(true);
    try {
      await _taskRepo.insertTask(task);
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

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


List<Task> get favoriteTasks =>
    _tasks.where((task) => task.isFavorite).toList();

Future<void> toggleFavorite(Task task) async {
  final newValue = !task.isFavorite;

  await _taskRepo.toggleFavorite(task.id!, newValue);

  task.isFavorite = newValue;
  notifyListeners();
}

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}