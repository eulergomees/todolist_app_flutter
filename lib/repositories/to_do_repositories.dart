import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistpage/models/todo.dart';

const todoListKey = 'todo_list';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todo) {
    final String jsonString = json.encode(todo);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
