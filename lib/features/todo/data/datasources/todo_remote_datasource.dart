import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/providers/api_helper.dart';
import '../../../../core/util/app_constants.dart';
import '../models/todo_model.dart';
import '../models/todo_payload.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getAllTodos();
  Future<Map> addTodo(TodoPayload todoPayload);
}

class TodoRemoteDataSourceImpl extends TodoRemoteDataSource{

  final Dio dio;
  TodoRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<Map> addTodo(TodoPayload todoPayload) async{
    print("----------------------todoPayload.toJson()");
    print(todoPayload.toJson());
    dio..options.connectTimeout = 150000; // Fix [DioErrorType.connectTimeout]
    try {
      final response = await APIHelper(
        dio: dio,
        apiBaseUrl: AppConstants.base_url,
      ).post(
        "/todo.json",
        body: todoPayload.toJson(),
      );
      return response;
    } on DioError catch (error) {
      throw RequestException.fromDioError(error);
    }
  }

  @override
  Future<List<TodoModel>> getAllTodos() async{
    try {
      final Response response = await APIHelper(
        dio: dio,
        apiBaseUrl: AppConstants.base_url,
      ).get("/todo.json");
      print("---------------------");
      print(response.data);
      final Map<String, dynamic> jsonListMap = response.data;
      List<TodoModel> result = [];
      for(var key in jsonListMap.keys){
        result.add(TodoModel.fromMap(jsonListMap[key]!, key));
      }
      return result;
    } on DioError catch (error) {
      throw RequestException.fromDioError(error);
    }
  }
}
