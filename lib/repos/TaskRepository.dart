import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class TaskRepository {

  final CollectionReference _collection = 
      FirebaseFirestore.instance.collection('tasks');
  
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> insertTask(Task task) async {
    task.userId = currentUserId;
    await _collection.add(task.toMap());
  }

  Future<List<Task>> getTasks() async {
    if (currentUserId == null) return [];

    final QuerySnapshot snapshot = await _collection
        .where('userId', isEqualTo: currentUserId)
        // .orderBy('dueDate') 
        .get();
    return snapshot.docs.map((doc) {
      return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> updateTask(Task task) async {
    if (task.id != null) {
      await _collection.doc(task.id).update(task.toMap());
    }
  }

  Future<void> deleteTask(String id) async {
    await _collection.doc(id).delete();
  }
}