import '../models/task.dart';
import '../repos/TaskRepository.dart';

class TaskService {
  final TaskRepository _repo = TaskRepository();

  Future<List<Task>> getAllTasks() async {
    return await _repo.getTasks();
  }

  Future<void> addTask(Task task) async {
    if (task.title.trim().isEmpty) {
      throw Exception("Title cannot be empty");
    }
    await _repo.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    if (task.id == null) {
      throw Exception("Task ID is required for update");
    }

    await _repo.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _repo.deleteTask(id);
  }
}
