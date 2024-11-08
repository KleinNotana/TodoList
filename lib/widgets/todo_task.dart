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
    bool _isCompleted = false;

  void _toggleCompletion() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
  }

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.todoTask.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
      value: widget.todoTask.isDone,
      onChanged: (bool? value) {

        _toggleCompletion();
        widget.onToggleCompletion(_isCompleted);
      },
      ),
      title: Text(
       widget.todoTask.title,
        style: TextStyle(
          decoration: widget.todoTask.isDone ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: widget.todoTask.description != null ? Text(widget.todoTask.description!) : null,
    );
  }
}
