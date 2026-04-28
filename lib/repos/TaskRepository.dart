import '../models/task.dart';
import '../services/api.dart';
import '../services/storage_service.dart';
import 'dart:convert';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<void> insertTask(Task task) async {
    final token = await _storageService.getToken();
    print("token in repo: ${token != null ? "[REDACTED]" : "None"}");
    if (token == null) {
      throw Exception("No authentication token found. Please login.");
    }
    print("the task to be added: ${task.toMap()}");

    await _apiService.post('/tasks/add', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception("No authentication token found. Please login.");
    }

    final response = await _apiService.get('/tasks');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Task.fromMap(item as Map<String, dynamic>, item['id'])).toList();
    } else {
      throw Exception("Failed to load tasks: ${response.statusCode}");
    }
  }

  Future<void> updateTask(Task task) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception("No authentication token found. Please login.");
    }

    if (task.id != null) {
      await _apiService.patch('/tasks/${task.id}', task.toMap());
    }
  }

  Future<void> deleteTask(String id) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception("No authentication token found. Please login.");
    }

    await _apiService.delete('/tasks/$id');
  }
}