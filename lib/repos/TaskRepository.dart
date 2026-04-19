import '../database/db_helper.dart';
import '../models/task.dart';


class TaskRepository {
  Future<int> insert(Task task) async {
    final db = await DBHelper.database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAll() async {
    final db = await DBHelper.database;
    final data = await db.query('tasks');
    return data.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> update(Task task) async {
    final db = await DBHelper.database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> delete(int id) async {
    final db = await DBHelper.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

}