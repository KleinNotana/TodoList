import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:todolist/models/todotask.dart';
import 'package:todolist/services/hiveservice.dart';

class TodoListService {
  final HiveService hiveService = HiveService.instance;
  final String todolist = 'todolist';
  TodoListService._privateConstructor();
  static final TodoListService _instance =
      TodoListService._privateConstructor();
  static TodoListService get instance => _instance;

  Future<Map<String, dynamic>> getTodoList() async {
    String jsonString = await hiveService.get(todolist) ?? "";
    if (jsonString != "") {
      return jsonDecode(jsonString);
    } else {
      return <String, dynamic>{};
    }
  }

  Future<void> setTodoList(Map<String, dynamic> historyData) async {
    await hiveService.put(todolist, jsonEncode(historyData));
  }

  Future<void> deleteTodoList() async {
    await hiveService.delete(todolist);
  }

  Future<void> closeBox() async {
    await hiveService.closeBox();
  }

  Future updateTodoTask(TodotaskModel todotask) async {
    var todolistData = await getTodoList();

    String formattedDate = todotask.dueDate != null
        ? DateFormat('yyyy-MM-dd').format(todotask.dueDate!)
        : "No duedate";

    todolistData[formattedDate] = todolistData[formattedDate]
        .map((task) =>
            task['createdDate'] == todotask.createdDate.toIso8601String()
                ? todotask.toJson()
                : task)
        .toList();
    await setTodoList(todolistData);
  }

  Future deleteTodoTask(TodotaskModel todotask) async {
    var todolistData = await getTodoList();
    String formattedDate = todotask.dueDate != null
        ? DateFormat('yyyy-MM-dd').format(todotask.dueDate!)
        : "No duedate";
    todolistData[formattedDate] =
        todolistData[formattedDate]
            .where((task) => task['createdDate'] != todotask.createdDate)
            .toList();
    await setTodoList(todolistData);
  }

  Future addTodoTask(TodotaskModel todotask) async {
    var todolistData = await getTodoList();
    String formattedDate = todotask.dueDate != null
        ? DateFormat('yyyy-MM-dd').format(todotask.dueDate!)
        : "No duedate";
    if (todolistData[formattedDate] ==
        null) {
      todolistData[formattedDate] = [];
    }
    todolistData[formattedDate]
        .add(todotask.toJson());
    await setTodoList(todolistData);
  }

  Future<List<TodotaskModel>> getTodoTaskList(DateTime dueDate) async {
    var todolistData = await getTodoList();
    if (todolistData[DateFormat('yyyy-MM-dd').format(dueDate)] == null) {
      return [];
    }
    return todolistData[DateFormat('yyyy-MM-dd').format(dueDate)]
        .map<TodotaskModel>((task) => TodotaskModel.fromJson(task))
        .toList();
  }

  Future<Map<String, List<TodotaskModel>>> getUpcomingTaskLists() async {
    var todolistData = await getTodoList();
    Map<String, List<TodotaskModel>> taskList = {};
    
    todolistData.forEach((date, tasks) {
        taskList[date] = tasks
            .map<TodotaskModel>((task) => TodotaskModel.fromJson(task))
            .toList();
  
    });

    return taskList;
  }


  Future<List<List<TodotaskModel>>> getAllTaskLists(
     ) async {
    var todolistData = await getTodoList();
    List<List<TodotaskModel>> taskList = [];
    
    todolistData.forEach((date, tasks) {
        taskList.add(tasks
            .map<TodotaskModel>((task) => TodotaskModel.fromJson(task))
            .toList());
      
    });

    return taskList;
  }
  
}
