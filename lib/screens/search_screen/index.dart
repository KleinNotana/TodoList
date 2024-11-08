import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todotask.dart';
import 'package:todolist/services/todolist_service.dart';
import 'package:todolist/utils/todo_notification.dart';
import 'package:todolist/widgets/todo_list.dart';
import 'package:todolist/widgets/add_new_todo_modal_bottom.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<List<TodotaskModel>> todoLists = [];
  List<List<TodotaskModel>> filteredTodoLists = [];
  TodoListService todoListService = TodoListService.instance;
  TextEditingController searchController = TextEditingController();
  TodoNotification todoNotification = TodoNotification();

  void loadTodoList() {
    todoListService.getAllTaskLists().then((value) {
      setState(() {
        todoLists = value;
      });
    });
  
  }


  void updateTodoTask(TodotaskModel task) {
    todoListService.updateTodoTask(task);
    setState(() {
      todoLists = todoLists.map((list) => list.map((e) => e.createdDate == task.createdDate ? task : e).toList()).toList();
      filteredTodoLists = filteredTodoLists.map((list) => list.map((e) => e.createdDate == task.createdDate ? task : e).toList()).toList();
    });

    if(task.isDone){
      todoNotification.cancelNotification(task);
    }
    else{
      todoNotification.showNotification(task);
    }
  }

  void _filterTodoList(String query) {
    setState(() {
      filteredTodoLists = todoLists
          .map((list) => list.where((task) => task.title.toLowerCase().contains(query.toLowerCase())).toList())
          .where((list) => list.isNotEmpty)
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
        title: Text('Search', style: Theme.of(context).textTheme.headlineLarge),
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
      body: ListView.builder(
        itemCount: filteredTodoLists.length,
        itemBuilder: (context, index) {
          final items = filteredTodoLists[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${DateFormat.MMMd().format(filteredTodoLists[index][0].dueDate!)} • ${DateFormat('EEEE').format(filteredTodoLists[index][0].dueDate!)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (items.isNotEmpty)
                TodoList(items: items, updateTodoTask: updateTodoTask,isHideCompletedTasks: false,),
            ],
          );
        },
      )
    );
  }
}