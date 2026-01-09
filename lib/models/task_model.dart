// lib/models/task_model.dart

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String? projectId;  // <-- String? kar do (nullable)

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    this.projectId,  // required nahi
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['due_date']),
      isCompleted: json['is_completed'],
      projectId: json['project_id'],  // null bhi ho sakta hai
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
      if (projectId != null) 'project_id': projectId,  // sirf agar null nahi to bhejo
    };
  }
}