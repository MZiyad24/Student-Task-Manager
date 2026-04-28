
class Task {
  String? id; 
  String title;
  String? description;
  DateTime dueDate;
  String priority;

  Task({
    this.id, 
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'],
      priority: map['priority'] ?? 'Medium',
      dueDate: DateTime.parse(map['dueDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}