import 'package:flutter/material.dart';
import 'package:todolist/models/todotask.dart';
import 'package:todolist/services/todolist_service.dart';
import 'package:todolist/widgets/todo_task.dart';

class TodoList extends StatefulWidget {
  final List<TodotaskModel> items;
  bool isHideCompletedTasks;
  final Function(TodotaskModel) updateTodoTask;

  TodoList({Key? key, required this.items, required this.updateTodoTask,this.isHideCompletedTasks = true}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  @override
  Widget build(BuildContext context) {
    // Sort items by priority ascending and createdDate descending
    final sortedItems = List<TodotaskModel>.from(widget.items)
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return a.priority.compareTo(b.priority);
        } else {
          return b.createdDate.compareTo(a.createdDate);
        }
      });

    // Filter out completed tasks if isHideCompletedTasks is true
    final filteredItems = widget.isHideCompletedTasks
        ? sortedItems.where((item) => !item.isDone).toList()
        : sortedItems;

    return SingleChildScrollView(
      child: Column(
        children: filteredItems.map((item) {
        return TodoTask(todoTask: item, onToggleCompletion: (isCompleted) {
          item.isDone = isCompleted;
          widget.updateTodoTask(item);
        });
        }).toList(),
      ),
    );
  }
}