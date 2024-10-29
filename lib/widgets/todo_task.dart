import 'package:flutter/material.dart';
import 'package:todolist/models/todotask.dart';

class TodoTask extends StatefulWidget {
  final TodotaskModel todoTask;
  final void Function(bool) onToggleCompletion;

  const TodoTask({
    Key? key,
    required this.todoTask,
    required this.onToggleCompletion,
  }) : super(key: key);

  @override
  _TodoTaskState createState() => _TodoTaskState();
}

class _TodoTaskState extends State<TodoTask> {
  late bool _isCompleted = widget.todoTask.isDone;

  void _toggleCompletion() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Radio(
        value: _isCompleted,
        groupValue: true,
        onChanged: (bool? value) {
          _toggleCompletion();
          widget.onToggleCompletion(_isCompleted);
        },
      ),
      title: Text(
        _isCompleted ? 'Completed: ${widget.todoTask.title}' : widget.todoTask.title,
        style: TextStyle(
          decoration: _isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: widget.todoTask.description != null ? Text(widget.todoTask.description!) : null,
      onTap: _toggleCompletion,
    );
  }
}