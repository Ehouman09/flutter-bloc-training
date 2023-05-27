import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/hive_helper.dart';
import '../../../../core/util/app_constants.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getAllTodosFromLocal();
  Future<void> cacheTodos(List<TodoModel> todos);
}

class TodoLocalDataSourceImpl extends TodoLocalDataSource{
  final HiveInterface hive;

  TodoLocalDataSourceImpl({required this.hive});

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async{
    try {
      HiveHelper hiveHelper = HiveHelper(hive: hive);
      final String todoList = json.encode(todos);
      await hiveHelper.setValue(AppConstants.todoKey, todoList);
    } catch (e) {
      print(e);
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<List<TodoModel>> getAllTodosFromLocal() async{
    try {
      HiveHelper hiveHelper = HiveHelper(hive: hive);
      final String resultString = hiveHelper.getValue(AppConstants.todoKey);
      final List result = json.decode(resultString);
      final List<TodoModel> todoModelList = result.map((item) => TodoModel.fromCache(item)).toList();
      return todoModelList;
    } catch (e) {
      print(e);
      throw CacheFailure(message: e.toString());
    }
  }
}