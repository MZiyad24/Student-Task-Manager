class Task {
  String? id;
  String title;
  String? description;
  DateTime dueDate;
  String priority;
  bool isFavorite;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    this.isFavorite = false,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'],
      priority: map['priority'] ?? 'Medium',
      dueDate: DateTime.parse(map['dueDate']),
      isFavorite: map['isFavorite'] ?? false,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}