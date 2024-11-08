import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todotask.dart';
import 'package:todolist/services/todolist_service.dart';
import 'package:todolist/utils/todo_notification.dart';
import 'package:todolist/widgets/todo_list.dart';
import 'package:todolist/widgets/add_new_todo_modal_bottom.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  Map<String, List<TodotaskModel>> todoLists = {};
  TodoListService todoListService = TodoListService.instance;
  TodoNotification todoNotification = TodoNotification();

  List<DateTime> upcomingDates = [];

  void generateUpcomingDates() {
    DateTime today = DateTime.now();
    for (int i = 0; i < 365; i++) {
      upcomingDates.add(today.add(Duration(days: i)));
    }
  }

  void loadTodoList() {
    todoListService.getUpcomingTaskLists().then((value) {
      setState(() {
        todoLists = value;
      });
    });
  }

  void _addNewTodoTask(TodotaskModel newTask) {
    setState(() {
      todoLists[DateFormat('yyyy-MM-dd').format(newTask.dueDate!)] = [
        ...todoLists[DateFormat('yyyy-MM-dd').format(newTask.dueDate!)]!,
        newTask
      ];
    });
    todoListService.addTodoTask(newTask);
    todoNotification.showNotification(newTask);
  }

  void updateTodoTask(TodotaskModel task) {
    todoListService.updateTodoTask(task);
    setState(() {
      todoLists[DateFormat('yyyy-MM-dd').format(task.dueDate!)] =
          todoLists[DateFormat('yyyy-MM-dd').format(task.dueDate!)]!
              .map((e) => e.createdDate == task.createdDate ? task : e)
              .toList();
    });
    TodoNotification().cancelNotification(task);
  }

  @override
  void initState() {
    super.initState();
    loadTodoList();
    generateUpcomingDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Upcoming', style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: ListView.builder(
        itemCount: upcomingDates.length,
        itemBuilder: (context, index) {
          final items = todoLists[
                  DateFormat('yyyy-MM-dd').format(upcomingDates[index])] ??
              [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${DateFormat.MMMd().format(upcomingDates[index])} • ${DateFormat('EEEE').format(upcomingDates[index])}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (items.isNotEmpty)
                TodoList(items: items, updateTodoTask: updateTodoTask),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            builder: (context) {
              return AddNewTodoModalBottom(onAdd: _addNewTodoTask);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
