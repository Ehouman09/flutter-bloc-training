import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:notey/features/todo/data/models/todo_model.dart';
import 'package:notey/features/todo/domain/entities/todo.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final todoList = [
    TodoModel(id: "-NM1M6H7ezZk2AK59VPf", title: "This is a title", description: "This a description text", color: "0xffe04f59"),
    TodoModel(id: "-NM1MCEfJ9ypXrJiVUvE", title: "This is a title", description: "This a description text", color: "0xfff1f4f6"),
    TodoModel(id: "-NMwhYv5zg4vDQGTcz8c", title: "This is a title", description: "This a description text",color:  "0xff284059")
  ];

  test(
    'should be a subclass of Todo entity',
        () async {
      // assert
      expect(todoList, isA<List<Todo>>());
    },
  );

  test(
    'should return a valid list of model',
        () async {
      // arrange
      final Map<String, dynamic> jsonListMap = json.decode(fixture('todoList.json'));
      List<TodoModel> result = [];
      for(var key in jsonListMap.keys){
        // act
        result.add(TodoModel.fromMap(jsonListMap[key]!, key));
      }
      // assert
      expect(result, todoList);
    },
  );

  test(
    'should return a JSON map containing the proper data',
        () async {
      // act
      final result = todoList[0].toMap();
      // assert
      final expectedJsonMap = {
        'id': '-NM1M6H7ezZk2AK59VPf',
        'title': "This is a title",
        'description': "This a description text",
        'color': "0xffe04f59",
      };
      expect(result, expectedJsonMap);
    },
  );
}