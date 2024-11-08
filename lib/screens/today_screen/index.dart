import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todotask.dart';
import 'package:todolist/services/todolist_service.dart';
import 'package:todolist/utils/todo_notification.dart';
import 'package:todolist/widgets/todo_list.dart';
import 'package:todolist/widgets/add_new_todo_modal_bottom.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<TodotaskModel> todoList = [];
  List<TodotaskModel> filteredTodoList = [];
  TodoListService todoListService = TodoListService.instance;
  TextEditingController searchController = TextEditingController();
  TodoNotification todoNotification = TodoNotification();
  
  void loadTodoList() {
    todoListService.getTodoTaskList(DateTime.now()).then((value) {
      setState(() {
        todoList = value;
        filteredTodoList = value;
      });
    });
  }

  void _addNewTodoTask(TodotaskModel newTask) {
    setState(() {
      todoList.add(newTask);
      filteredTodoList = todoList;
    });
    todoListService.addTodoTask(newTask);
    todoNotification.showNotification(newTask);
  }

  void updateTodoTask(TodotaskModel task) {
    todoListService.updateTodoTask(task);
    setState(() {
      todoList = todoList.map((e) => e.createdDate == task.createdDate ? task : e).toList();
      filteredTodoList = filteredTodoList.map((e) => e.createdDate == task.createdDate ? task : e).toList();
    });
    todoNotification.cancelNotification(task);
  }

  void _filterTodoList(String query) {
    setState(() {
      filteredTodoList = todoList
          .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTodoList();
    searchController.addListener(() {
      _filterTodoList(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today', style: Theme.of(context).textTheme.headlineLarge),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${DateFormat.MMMd().format(DateTime.now())} • ${DateFormat('EEEE').format(DateTime.now())}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: TodoList(items: filteredTodoList, updateTodoTask: updateTodoTask),
          ),
        ],
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