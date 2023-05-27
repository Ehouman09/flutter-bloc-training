import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notey/core/providers/api_helper.dart';
import 'package:notey/core/util/app_constants.dart';
import 'package:notey/features/todo/data/models/todo_payload.dart';
import '../../fixtures/fixture_reader.dart';
import 'api_helper_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {

  final Dio dio = Dio();
  late MockHttpClientAdapter dioAdapterMock;
  late APIHelper apiHelper;
  setUp(() {
    dioAdapterMock = MockHttpClientAdapter();
    dio.httpClientAdapter = dioAdapterMock;
    apiHelper = APIHelper.test(dio: dio, apiBaseUrl: AppConstants.base_url);
  });

  group('Get method', () {
    test('Should be used to get responses for any url', () async {
      final httpResponse = ResponseBody.fromString(
        fixture('todoList.json'),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await apiHelper.get("/todo.json");
      final expected = jsonDecode(fixture('todoList.json'));

      expect(response.data, equals(expected));
    });
  });

  group('Post Method', () {
    test('Should be used to get responses for any requests with body', () async {
      final responsePayload = jsonEncode({
        "name": "-NMwhYv5zg4vDQGTcz8c"
      });
      final httpResponse =
      ResponseBody.fromString(responsePayload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await apiHelper.post("/todo.json", body: TodoPayload(color: "red", description: "This a description text", title: "This is a title").toJson());
      final expected = {
        "name": "-NMwhYv5zg4vDQGTcz8c"
      };

      expect(response, equals(expected));
    });
  });
}