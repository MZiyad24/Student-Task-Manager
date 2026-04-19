import '../database/db_helper.dart';
import '../models/user.dart';

class UserRepository {
  Future<int> insertUser(User user) async {
    final db = await DBHelper.database;
    return db.insert('users', user.toMap());
  }

  // login

  // signup

  // get user
  Future<User?> getUserById(int id) async {
    final db = await DBHelper.database;
    final data = await db.query('users', where: 'studentId = ?', whereArgs: [id]);
    if (data.isNotEmpty) {
      return User.fromMap(data.first);
    }
    return null;
  }

  // update user
  Future<int> updateUser(User user) async {
    final db = await DBHelper.database;
    return db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  
}