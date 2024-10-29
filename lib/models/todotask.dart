class TodotaskModel {
  String title;
  String? description;
  DateTime? dueDate;
  DateTime? reminderDate;
  bool isDone;

  TodotaskModel({
    required this.title,
    this.description,
    this.dueDate,
    this.reminderDate,
    this.isDone = false,
  });

}