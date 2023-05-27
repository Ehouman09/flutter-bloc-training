import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notey/core/error/exceptions.dart';
import 'package:notey/core/providers/api_helper.dart';
import 'package:notey/core/util/app_constants.dart';
import 'package:notey/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:notey/features/todo/data/models/todo_model.dart';
import 'package:notey/features/todo/data/models/todo_payload.dart';
import '../../../../core/providers/api_helper_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  final Dio dio = Dio();
  late MockHttpClientAdapter dioAdapterMock;
  late APIHelper apiHelper;
  late TodoRemoteDataSourceImpl dataSource;

  final todoList = [
    TodoModel(id: "-NM1M6H7ezZk2AK59VPf", title: "This is a title", description: "This a description text", color: "0xffe04f59"),
    TodoModel(id: "-NM1MCEfJ9ypXrJiVUvE", title: "This is a title", description: "This a description text", color: "0xfff1f4f6"),
    TodoModel(id: "-NMwhYv5zg4vDQGTcz8c", title: "This is a title", description: "This a description text",color:  "0xff284059")
  ];

  ResponseBody httpResponse(int statusCode, dynamic data){
    return ResponseBody.fromString(
      data,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  setUp(() {
    dioAdapterMock = MockHttpClientAdapter();
    dio.httpClientAdapter = dioAdapterMock;
    apiHelper = APIHelper.test(dio: dio, apiBaseUrl: AppConstants.base_url);
    dataSource = TodoRemoteDataSourceImpl(dio: dio);
  });

  group('getAllTodos', (){
    test(
      'should return a List<TodoModel> when the response code is 200 (success)',
          () async {

        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse(200, fixture('todoList.json')));

        final result = await dataSource.getAllTodos();

        expect(result, todoList);
      },
    );

    test('should throw a ServerException when the response code is 404 or other',
            () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse(404, 'Something went wrong'));

          final call = dataSource.getAllTodos;

          expect(() => call(), throwsA(isInstanceOf<RequestException>()));
    });
  });

  group('addTodo', (){
    test(
      'should return a Map when the response code is 200 (success)',
          () async {

        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse(200, jsonEncode({"name": "-NMwhYv5zg4vDQGTcz8c"})));

        final result = await dataSource.addTodo(TodoPayload(color: "red", description: "This a description text", title: "This is a title"));
        final expected = {
          "name": "-NMwhYv5zg4vDQGTcz8c"
        };
        expect(result, equals(expected));
      },
    );

    test('should throw a ServerException when the response code is 404 or other',
            () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse(404, 'Something went wrong'));

            //final result = await dataSource.addTodo(TodoPayload(color: "red", description: "This a description text", title: "This is a title"));

            //expect(result, throwsA(TypeMatcher<RequestException>()));
            final call = dataSource.addTodo;

            expect(() => call(TodoPayload(color: "red", description: "This a description text", title: "This is a title")), throwsA(isInstanceOf<ServerException>()));
    });
  });
}