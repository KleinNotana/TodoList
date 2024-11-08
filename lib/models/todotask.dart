class TodotaskModel {
  String title;
  String? description;
  DateTime? dueDate;
  DateTime? reminderDate;
  DateTime createdDate;
  int priority;
  bool isDone;

  TodotaskModel({
    required this.title,
    this.description,
    this.dueDate,
    this.reminderDate,
    required this.createdDate,
    required this.priority,
    this.isDone = false,
  });


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'priority': priority,
      'isDone': isDone,
    };
  }

  factory TodotaskModel.fromJson(Map<String, dynamic> json) {
    return TodotaskModel(
      priority: json['priority'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      reminderDate: json['reminderDate'] != null ? DateTime.parse(json['reminderDate']) : null,
      createdDate: DateTime.parse(json['createdDate']),
      isDone: json['isDone'],
    );
  }
}