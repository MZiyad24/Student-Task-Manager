import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String? userId; // <--- ADD THIS
  String title;
  String? description;
  DateTime dueDate;
  String priority;
  bool isCompleted;

  Task({
    this.id,
    this.userId, // <--- ADD THIS
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // <--- ADD THIS
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      userId: map['userId'], // <--- ADD THIS
      title: map['title'] ?? '',
      description: map['description'],
      priority: map['priority'] ?? 'Medium',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}